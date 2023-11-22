extends CharacterBody2D;
class_name Player;

@export var JUMP_FORCE_MAX: float = 250.0;
@export var JUMP_TIME_START: float = 0.1;
@export var JUMP_TIME_MAX: float = 1.0;
@export var DASH_FORCE: float = 100.0;
@export var MAX_VELOCITY: float = 750.0;

@onready var animation_player = $AnimationPlayer;
@onready var sprite = $Sprite2D;
@onready var ball_sprite = $Sprite2D2;
@onready var base_scale: Vector2 = sprite.scale;

const FRICTION: int = 10;
const GRAVITY: int = 10;
const ADDITIONAL_GRAVITY: int = 3;
const WALL_SLIDING_GRAVITY: int = 6;

var is_charging_jump = false;
var current_jump_time = JUMP_TIME_START;

var is_mouse_in_box = false;
var mouse_position = null;
var direction;
var on_ground = false;

var elastic = 0.99;
var sub_elastic = 0.09;

var hold_right_button = false;

var is_wall_sliding = false;

var dash_mode = false;
var dash_count = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func _physics_process(delta):
	apply_gravity();
	mouse_position = get_global_mouse_position();
	direction = global_position.direction_to(mouse_position);
	ball_sprite.visible = false;
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		hold_right_button = true;
		ball_sprite.visible = true;
		sprite.visible = false;
	else:
		hold_right_button = false;
		ball_sprite.visible = false;
		sprite.visible = true;
	
	scale_based_on_velocity();
	
	if is_mouse_in_box:
		if is_on_floor():
			if Input.is_action_pressed("left_click"):
				is_charging_jump = true;
				if is_charging_jump:
					current_jump_time += delta * 2;
					current_jump_time = clamp(current_jump_time, JUMP_TIME_START, JUMP_TIME_MAX);
					animation_player.play("charge_jump");
			if Input.is_action_just_released("left_click"):
				is_charging_jump = false;
				animation_player.play("release_jump");
				jumping_movement();
			if hold_right_button:
				if !dash_mode:
					apply_zero_friction();
					if velocity.x != 0:
						if get_slide_collision_count() > 0:
							var collision = get_slide_collision(0);
							if collision != null:
								velocity.y -= JUMP_FORCE_MAX * (elastic);
								elastic -= sub_elastic;
				if velocity.x > 0:
					ball_sprite.rotate(0.25);
				elif velocity.x < 0:
					ball_sprite.rotate(-0.25);
			else:
				apply_friction();
				elastic = 0.99;
				ball_sprite.rotation = 0;
		else:
			if velocity.y > 0:
				velocity.y += ADDITIONAL_GRAVITY;
		if dash_mode and dash_count != 0:
			if Input.is_action_just_pressed("hold_right_button"):
				dash_movement();
				dash_count = 0;
		if is_on_floor() or is_on_wall():
			dash_count = 1;
	elif !is_mouse_in_box:
		pass;
	
	if is_on_wall_only() and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		is_wall_sliding = true;
		$CollisionShape2D.shape.extents = Vector2(8, 4);
		sprite.rotation = 0;
		apply_wall_slide(delta);
	else:
		is_wall_sliding = false;
		$CollisionShape2D.shape.extents = Vector2(8, 8);
	
	if velocity.x > 0:
		sprite.flip_h = false;
		ball_sprite.flip_h = false;
	elif velocity.x < 0:
		sprite.flip_h = true;
		ball_sprite.flip_h = true;
	else:
		pass;
	
	if is_on_floor():
		if not on_ground:
			animation_player.play("landing");
		on_ground = true;
	else:
		on_ground = false;
	
	move_and_slide();
	change_jump_cursor();

func scale_based_on_velocity() -> void:
	if animation_player.is_playing(): return;
	sprite.scale = lerp(base_scale, base_scale * Vector2(0.5, 1.4), velocity.length()/MAX_VELOCITY);

func jumping_movement() -> void:
	velocity = direction * JUMP_FORCE_MAX * (current_jump_time / JUMP_TIME_MAX);
	current_jump_time = JUMP_TIME_START;

func dash_movement() -> void:
	direction = global_position.direction_to(mouse_position);
	velocity = direction * DASH_FORCE * 3;

func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y += GRAVITY;
		velocity.y = min(velocity.y, 200);

func apply_friction() -> void:
	velocity.x = move_toward(velocity.x, 0, FRICTION);

func apply_zero_friction() -> void:
	velocity.x = move_toward(velocity.x, 10, 0);

func apply_wall_slide(delta) -> void:
	if is_wall_sliding:
		velocity.y += WALL_SLIDING_GRAVITY;
		velocity.y = min(velocity.y, WALL_SLIDING_GRAVITY * 3);
		if Input.is_action_pressed("left_click"):
			is_charging_jump = true;
			if is_charging_jump:
				current_jump_time += delta * 2;
				current_jump_time = clamp(current_jump_time, JUMP_TIME_START, JUMP_TIME_MAX);
		if Input.is_action_just_released("left_click"):
			is_charging_jump = false;
			jumping_movement();

func change_jump_cursor() -> void:
	if is_on_floor() or is_on_wall():
		$JumpCursor.animation = "default";
	if current_jump_time > 0.2 and current_jump_time < 0.4:
		$JumpCursor.animation = "jump1";
	if current_jump_time > 0.4 and current_jump_time < 0.6:
		$JumpCursor.animation = "jump2";
	if current_jump_time > 0.6 and current_jump_time < 0.9:
		$JumpCursor.animation = "jump3";
	if current_jump_time > 0.9 and current_jump_time <= 1.0:
		$JumpCursor.animation = "jump4";

func _on_area_2d_mouse_entered():
	is_mouse_in_box = true;

func _on_area_2d_mouse_exited():
	is_mouse_in_box = false;
