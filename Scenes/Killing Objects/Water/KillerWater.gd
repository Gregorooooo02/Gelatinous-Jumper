extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_overlapping_bodies():
		_on_body_entered(Player)

func _on_body_entered(body):
	if body is Player:
		if body.dash_mode == false and body.hold_right_button == false:
			get_node("/root/Main").reset_coins()
			get_tree().reload_current_scene();
		if body.dash_mode == true:
			get_node("/root/Main").reset_coins()
			get_tree().reload_current_scene();
	
