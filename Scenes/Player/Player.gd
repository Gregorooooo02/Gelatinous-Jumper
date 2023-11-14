extends CharacterBody2D;

@export var JUMP_FORCE_MAX: int = 220;
@export var FRICTION: int = 10;
@export var GRAVITY: int = 10;
@export var ADDITIONAL_GRAVITY: int = 3;
@export var WALL_SLIDING_GRAVITY: int = 6;

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
			if Input.is_action_just_pressed("left_click"):
				jumping_movement();
			elif hold_right_button:
				apply_zero_friction();
			else:
				apply_friction();
		else:
			if velocity.y > 0:
				velocity.y += ADDITIONAL_GRAVITY;
	
	if is_on_wall() and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		is_wall_sliding = true;
		$CollisionShape2D.shape.extents = Vector2(8, 4);
		apply_wall_slide();
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
	velocity = direction * JUMP_FORCE_MAX;

func apply_gravity():
	velocity.y += GRAVITY;
	velocity.y = min(velocity.y, 200);

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION);

func apply_zero_friction():
	velocity.x = move_toward(velocity.x, 10, 0);

func apply_wall_slide():
	if is_wall_sliding:
		velocity.y += WALL_SLIDING_GRAVITY;
		velocity.y = min(velocity.y, WALL_SLIDING_GRAVITY * 3);
		if Input.is_action_just_pressed("left_click"):
			jumping_movement();
	else:
		pass;

func _on_area_2d_mouse_entered():
	is_mouse_in_box = true;

func _on_area_2d_mouse_exited():
	is_mouse_in_box = false;
