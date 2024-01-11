extends Area2D

func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://Scenes/Levels/Screens/End_Screen.tscn");
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE);
