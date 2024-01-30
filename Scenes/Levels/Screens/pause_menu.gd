extends Node2D

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;

var is_main_menu = false;

func _ready():
	$VBoxContainer.size = Vector2(480, 270);
	$VBoxContainer.custom_minimum_size = Vector2(480, 270);

func _on_animation_player_animation_finished(anim_name):
	Global.is_paused = false;
	get_tree().paused = false;
	if is_main_menu:
		get_tree().change_scene_to_file("res://Main.tscn");


func _on_main_menu_pressed():
	confirm_sound.play();
	is_main_menu = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();
	print("Pressed main menu");


func _on_resume_pressed():
	confirm_sound.play();
	Global.is_paused = false;
	get_tree().paused = false;
