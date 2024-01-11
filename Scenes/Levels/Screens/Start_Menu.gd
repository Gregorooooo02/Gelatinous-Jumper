extends Node

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus();
	$AnimationPlayer.play("Start");

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1/Level_1.tscn");


func _on_options_pressed():
	print("Options pressed");


func _on_exit_pressed():
	get_tree().quit();
