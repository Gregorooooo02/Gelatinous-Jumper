extends Node

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;
@onready var timer = $Timer;

@onready var firework : GPUParticles2D = $Fireworks;
@onready var firework2 : GPUParticles2D = $Fireworks2;
@onready var firework3 : GPUParticles2D = $Fireworks3;

var fireworks;
var played = false;

var is_next_level = false;
var is_main_menu = false;

var index = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	$FrontTiles/NextLevel/Next_Level.grab_focus();
	fireworks = [firework, firework2, firework3]

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

func _on_timer_timeout():
	fireworks[index].emitting = true;
	fireworks[index].one_shot = false;
	$FireworkSFX.play();
	index += 1;
	
	if index > 2:
		index = 0;
