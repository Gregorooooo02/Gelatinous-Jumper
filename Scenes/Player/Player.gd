extends CharacterBody2D;

@export var JUMP_FORCE_MAX: int = 200;
@export var FRICTION: int = 10;
@export var GRAVITY: int = 5;
@export var ADDITIONAL_GRAVITY: int = 3;

var mouse_position = null;
var direction;

var hold_right_button = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	apply_gravity();
	mouse_position = get_global_mouse_position();
	
	if is_on_floor():
		if Input.is_mouse_button_pressed(1):
			direction = (mouse_position - position).normalized();
			velocity = direction * JUMP_FORCE_MAX;
	else:
		if velocity.y > 0:
			velocity.y += ADDITIONAL_GRAVITY;
	
	if is_on_floor():
		if hold_right_button:
			apply_zero_friction();
		else:
			apply_friction();
	
	if Input.is_action_pressed("hold_right_button"):
		hold_right_button = true;
	elif Input.is_action_just_released("hold_right_button"):
		hold_right_button = false;
	
	
	set_velocity(velocity)
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity;
	#look_at(mouse_position);

func apply_gravity():
	velocity.y += GRAVITY;

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION);

func apply_zero_friction():
	velocity.x = move_toward(velocity.x, 10, 0);
