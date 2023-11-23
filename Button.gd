extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_StartButton_pressed)

func _on_StartButton_pressed():
	# Change the scene when the button is pressed
	get_tree().change_scene_to_file("res://World.tscn")
