extends Node

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;

var is_level_1 = false;
var is_level_2 = false;

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus();
	$AnimationPlayer.play("Start");
	
	$VBoxContainer.size = Vector2(480, 270);
	$VBoxContainer.custom_minimum_size = Vector2(480, 270);

func _on_start_pressed():
	confirm_sound.play();
	$AnimationPlayer.play("To_Levels");

func _on_exit_pressed():
	confirm_sound.play();
	get_tree().quit();


# Levels selection
func _on_level_1_text_pressed():
	$CutOutAnimation.visible = true;
	confirm_sound.play();
	is_level_1 = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();


func _on_level_2_text_pressed():
	$CutOutAnimation.visible = true;
	confirm_sound.play();
	is_level_2 = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();


func _on_animation_player_animation_finished(anim_name):
	if is_level_1:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level1/Level_1.tscn");
	elif is_level_2:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level2/Level_2.tscn");
