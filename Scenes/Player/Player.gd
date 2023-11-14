extends CharacterBody2D;

const JUMP_FORCE_MAX: int = 250;
const JUMP_TIME_START: float = 0.2;
const JUMP_TIME_MAX: float = 1.0;
const FRICTION: int = 10;
const GRAVITY: int = 10;
const ADDITIONAL_GRAVITY: int = 3;
const WALL_SLIDING_GRAVITY: int = 6;

var is_charging_jump = false;
var current_jump_time = JUMP_TIME_START;

var is_mouse_in_box = false;
var mouse_position = null;
var direction;

var hold_right_button = false;

var is_wall_sliding = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func _physics_process(delta):
	apply_gravity();
	mouse_position = get_global_mouse_position();
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		hold_right_button = true;
		$AnimatedSprite2D.animation = "Rolling";
	else:
		hold_right_button = false;
		$AnimatedSprite2D.animation = "Idle";
	
	if is_mouse_in_box:
		if is_on_floor():
			if Input.is_action_pressed("left_click"):
				is_charging_jump = true;
				if is_charging_jump:
					current_jump_time += delta * 2;
					current_jump_time = clamp(current_jump_time, JUMP_TIME_START, JUMP_TIME_MAX);
			if Input.is_action_just_released("left_click"):
				is_charging_jump = false;
				jumping_movement();
			if hold_right_button:
				apply_zero_friction();
				if velocity.x > 0:
					$AnimatedSprite2D.rotate(0.25);
				elif velocity.x < 0:
					$AnimatedSprite2D.rotate(-0.25);
			else:
				apply_friction();	
				$AnimatedSprite2D.rotation = 0;
		else:
			if velocity.y > 0:
				velocity.y += ADDITIONAL_GRAVITY;
	
	if is_on_wall() and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		is_wall_sliding = true;
		$CollisionShape2D.shape.extents = Vector2(8, 4);
		$AnimatedSprite2D.rotation = 0;
		apply_wall_slide(delta);
	else:
		is_wall_sliding = false;
		$CollisionShape2D.shape.extents = Vector2(8, 8);
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false;
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true;
	else:
		pass;
	
	#look_at(mouse_position);
	move_and_slide();

func jumping_movement():
	direction = global_position.direction_to(mouse_position);
	velocity = direction * JUMP_FORCE_MAX * (current_jump_time / JUMP_TIME_MAX);
	current_jump_time = JUMP_TIME_START;

func apply_gravity():
	velocity.y += GRAVITY;
	velocity.y = min(velocity.y, 200);

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION);

func apply_zero_friction():
	velocity.x = move_toward(velocity.x, 10, 0);

func apply_wall_slide(delta):
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

func _on_area_2d_mouse_entered():
	is_mouse_in_box = true;

func _on_area_2d_mouse_exited():
	is_mouse_in_box = false;
