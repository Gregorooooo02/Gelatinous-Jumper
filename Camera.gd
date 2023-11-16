extends Camera2D

var player
var target_position = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.distance_to(target_position) < 60: # Change 100 to your desired proximity threshold
		# Adjust the camera's position to a new location
		position = Vector2(-60, -10)
