extends KinematicBody2D;

export(int) var JUMP_FORCE_MAX = 200;
export(int) var FRICTION = 10;
export(int) var GRAVITY = 5;
export(int) var ADDITIONAL_GRAVITY = 3;

var velocity = Vector2.ZERO;

var mouse_position = null;
var direction;

var fast_fell = false;

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
	
	if !Input.is_mouse_button_pressed(1) and is_on_floor():
		apply_friction();
	
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP);
	#look_at(mouse_position);

func apply_gravity():
	velocity.y += GRAVITY;

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION);
