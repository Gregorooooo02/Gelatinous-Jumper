extends CharacterBody2D;

@export var JUMP_FORCE_MAX: int = 200;
@export var FRICTION: int = 10;
@export var GRAVITY: int = 5;
@export var ADDITIONAL_GRAVITY: int = 3;

var mouse_position = null;
var direction;

var hold_right_button = false;
var counter = 1;

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
			ball_bounce_of_floor(counter);
			counter += 1;
		else:
			apply_friction();
			counter = 0;
			
	if is_on_wall():
		if hold_right_button:
			ball_bounce_of_wall(counter);
			counter += 1;
	
	if Input.is_action_pressed("hold_right_button"):
		hold_right_button = true;
		$AnimatedSprite2D.animation = "Rolling";
	elif Input.is_action_just_released("hold_right_button"):
		hold_right_button = false;
		$AnimatedSprite2D.animation = "Idle";
	
	
	set_velocity(velocity)
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity;
	#look_at(mouse_position);

func apply_gravity():
	velocity.y += GRAVITY;
	velocity.y = min(velocity.y, 300);

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION);

func apply_zero_friction():
	velocity.x = move_toward(velocity.x, 10, 0);
	
func ball_bounce_of_floor(counter):
	velocity.y = move_toward(-JUMP_FORCE_MAX, 0, 60 * counter);
	
func ball_bounce_of_wall(counter):
	velocity.x = move_toward(- JUMP_FORCE_MAX, 0, 60 * counter);
