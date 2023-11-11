extends KinematicBody2D;

var speed = 200;
var velocity = Vector2.ZERO;
var mouse_position = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	apply_gravity();
	var input = Vector2.ZERO;
	mouse_position = get_global_mouse_position();
	
	if Input.is_mouse_button_pressed(1) and self.is_on_floor():
		var direction = (mouse_position - position).normalized();
		velocity = direction * speed;
	
	if !Input.is_mouse_button_pressed(1) && self.is_on_floor():
		velocity.x = 0;
	
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP);
	#look_at(mouse_position);
		

func apply_gravity():
	velocity.y += 4;
	
func apply_friction():
	pass;
	
