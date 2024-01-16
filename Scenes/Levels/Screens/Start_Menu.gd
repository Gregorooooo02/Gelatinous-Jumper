extends Node

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus();
	$AnimationPlayer.play("Start");
	
	$VBoxContainer.size = Vector2(480, 270);
	$VBoxContainer.custom_minimum_size = Vector2(480, 270);

func _on_start_pressed():
	$AnimationPlayer.play("To_Levels");


func _on_options_pressed():
	print("Options pressed");


func _on_exit_pressed():
	get_tree().quit();


# Levels selection
func _on_level_1_text_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1/Level_1.tscn");


func _on_level_2_text_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2/Level_2.tscn");
