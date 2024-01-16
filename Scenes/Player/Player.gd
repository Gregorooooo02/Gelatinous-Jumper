extends CharacterBody2D;
class_name Player;

@export var SLIME_CHUNKS: int = 4;
@export var JUMP_FORCE_MAX: float = 250.0;
@export var JUMP_TIME_START: float = 0.1;
@export var JUMP_TIME_MAX: float = 1.0;
@export var DASH_FORCE: float = 100.0;
@export var MAX_VELOCITY: float = 750.0;

@onready var animation_player = $AnimationPlayer;
@onready var sprite = $MainBody;
@onready var ball_sprite = $BallBody;
@onready var dash_sprite = $DashBody;
@onready var dash_sprite_ball = $DashBallBody;
@onready var sprite_eyes_body = $MainBody/PlayerEyes;
@onready var sprite_eyes_ball = $BallBody/PlayerEyes;
@onready var sprite_eyes_dash = $DashBody/PlayerEyes;
@onready var sprite_eyes_dash_ball = $DashBallBody/PlayerEyes;

@onready var base_scale: Vector2 = sprite.scale;
@onready var base_ball_scale: Vector2 = ball_sprite.scale;
@onready var player_arrow = $PlayerArrow;
@onready var player_arrow_animator = $PlayerArrow/AnimateArrow;
@onready var particles = $GPUParticles2D;
@onready var particles_dash = $DashParticles;
@onready var particles_dash_landing = $DashLandingParticles;

const FRICTION: int = 10;
const GRAVITY: int = 9;
const ADDITIONAL_GRAVITY: int = 3;
const WALL_SLIDING_GRAVITY: int = 6;

var is_charging_jump = false;
var current_jump_time = JUMP_TIME_START;

var mouse_position = null;
var direction;
var on_ground = false;
var can_jump = true;

var elastic = 0.99;
var sub_elastic = 0.09;

@export var hold_right_button = false;

var is_wall_sliding = false;

var dash_mode = false;
var dash_count = 1;

var follow_speed = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	player_arrow.visible = false;

func _process(_delta):
	rotate_player_arrow();

func _physics_process(delta):
	apply_gravity();
	mouse_position = get_global_mouse_position();
	direction = global_position.direction_to(mouse_position);
	ball_sprite.visible = false;
	dash_sprite.visible = false;
	dash_sprite_ball.visible = false;
	sprite_eyes_body.position = sprite_eyes_body.position.lerp(sprite.position, delta * follow_speed);
	sprite_eyes_ball.position = sprite_eyes_ball.position.lerp(ball_sprite.position, delta * follow_speed);
	sprite_eyes_dash.position = sprite_eyes_dash.position.lerp(dash_sprite.position, delta * follow_speed);
	sprite_eyes_dash_ball.position = sprite_eyes_dash_ball.position.lerp(dash_sprite_ball.position, delta * follow_speed);
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		hold_right_button = true;
		can_jump = false;
		if !dash_mode:
			ball_sprite.visible = true;
			sprite.visible = false;
		else:
			dash_sprite_ball.visible = true;
			dash_sprite.visible = false;
	else:
		hold_right_button = false;
		can_jump = true;
		if !dash_mode:
			ball_sprite.visible = false;
			sprite.visible = true;
		else:
			dash_sprite_ball.visible = false;
			dash_sprite.visible = true;
	
	scale_based_on_velocity();
	
	if is_on_floor():
		if Input.is_action_pressed("left_click") and can_jump:
			is_charging_jump = true;
			player_arrow.visible = true;
			if is_charging_jump:
				current_jump_time += delta * 2;
				current_jump_time = clamp(current_jump_time, JUMP_TIME_START, JUMP_TIME_MAX);
				if !dash_mode:
					animation_player.play("charge_jump");
				else:
					animation_player.play("charge_jump_dash");
				player_arrow_animator.play("charge_arrow");
		if Input.is_action_just_released("left_click"):
			is_charging_jump = false;
			if !dash_mode:
				animation_player.play("release_jump");
			else:
				animation_player.play("release_jump_dash");
			player_arrow_animator.play("RESET");
			jumping_movement();
			player_arrow.visible = false;
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
			particles_dash.restart();
			dash_movement();
			dash_count = 0;
	if is_on_floor() or is_on_wall():
		dash_count = 1;
	
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
		sprite_eyes_body.flip_h = false;
		sprite_eyes_ball.flip_h = false;
		sprite_eyes_dash.flip_h = false;
		sprite_eyes_dash_ball.flip_h = false;
	elif velocity.x < 0:
		sprite.flip_h = true;
		ball_sprite.flip_h = true;
		sprite_eyes_body.flip_h = true;
		sprite_eyes_ball.flip_h = true;
		sprite_eyes_dash.flip_h = true;
		sprite_eyes_dash_ball.flip_h = true;
	else:
		pass;
	
	if is_on_floor():
		if not on_ground:
			if !dash_mode:
				animation_player.play("landing");
			else:
				animation_player.play("landing_dash");
			if !dash_mode:
				particles.restart();
			else:
				particles_dash_landing.restart();
		on_ground = true;
	else:
		on_ground = false;
	
	move_and_slide();

func scale_based_on_velocity() -> void:
	if animation_player.is_playing(): return;
	sprite.scale = lerp(base_scale, base_scale * Vector2(0.5, 1.4), velocity.length()/MAX_VELOCITY);
	dash_sprite.scale = lerp(base_scale, base_scale * Vector2(0.5, 1.4), velocity.length()/MAX_VELOCITY);
	
	ball_sprite.scale = lerp(base_ball_scale, base_ball_scale * Vector2(1.4, 0.5), velocity.length()/MAX_VELOCITY);
	dash_sprite_ball.scale = lerp(base_scale, base_scale * Vector2(1.4, 0.5), velocity.length()/MAX_VELOCITY);
	
	if velocity.y != 0:
		ball_sprite.rotation = velocity.angle();
		dash_sprite_ball.rotation = velocity.angle();

func jumping_movement() -> void:
	velocity = lerp(velocity, Vector2(direction * JUMP_FORCE_MAX * (current_jump_time / JUMP_TIME_MAX)), 1.0);
	current_jump_time = JUMP_TIME_START;

func dash_movement() -> void:
	direction = global_position.direction_to(mouse_position);
	velocity = direction * DASH_FORCE * 3;

func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y += 0.95*GRAVITY;
		#velocity.y = min(velocity.y, 150); 
		#Sprawia, że spadamy ze stałą prędkością, co uniemożliwia dashowania w dół.

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
			player_arrow.visible = true;
			player_arrow_animator.play("charge_arrow");
			if is_charging_jump:
				current_jump_time += delta * 2;
				current_jump_time = clamp(current_jump_time, JUMP_TIME_START, JUMP_TIME_MAX);
		if Input.is_action_just_released("left_click"):
			is_charging_jump = false;
			player_arrow.visible = false;
			player_arrow_animator.play("RESET");
			jumping_movement();

func change_to_dash():
	dash_mode = true;
	ball_sprite.visible = false;
	sprite.visible = false;
	dash_sprite.visible = true;
	
func rotate_player_arrow():
	mouse_position = get_global_mouse_position();
	player_arrow.look_at(mouse_position);
