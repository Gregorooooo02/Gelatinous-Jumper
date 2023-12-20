extends Sprite2D

@export var FOLLOW_SPEED: int = 10;

@onready var eyes = $PlayerEyes;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	eyes.position = eyes.position.lerp(global_position, delta * FOLLOW_SPEED);
