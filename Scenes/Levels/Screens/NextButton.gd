extends Button;

func _on_pressed() -> void :
	get_node("../../Main").timer = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2/Level_2.tscn")
