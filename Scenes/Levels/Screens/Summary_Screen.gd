extends Node

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;
@onready var timer = $Timer;

var is_next_level = false;
var is_main_menu = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$FrontTiles/NextLevel/Next_Level.grab_focus();

func _on_next_level_pressed():
	confirm_sound.play();
	is_next_level = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();
	print("Pressed next level");
	

func _on_main_menu_pressed():
	confirm_sound.play();
	is_main_menu = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();
	print("Pressed main menu");
	

func _on_animation_player_animation_finished(anim_name):
	get_tree().paused = false;
	if is_next_level:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level2/Level_2.tscn");
	elif is_main_menu:
		get_tree().change_scene_to_file("res://Main.tscn");
	


func _on_animation_player_main_animation_finished(anim_name):
	timer.start();
	var played = false;
	var played2 = false;
	var played3 = false;
	
	var time_left = timer.get_time_left();
	
	if time_left == 1.0:
		$Fireworks.emitting = true;
		if not played:
			$FireworkSFX.play();
			played = true;
	if time_left >= 0.6 or time_left < 0.7:
		$Fireworks2.emitting = true;
		if not played2:
			$FireworkSFX.play();
			played2 = true;
	if time_left <= 0.6:
		$Fireworks2.emitting = true;
		if not played3:
			$FireworkSFX.play();
			played3 = true;
