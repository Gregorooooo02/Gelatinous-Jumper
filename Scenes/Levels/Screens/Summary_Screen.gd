extends Control

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;

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
	

func _on_main_menu_pressed():
	confirm_sound.play();
	is_main_menu = true;
	$CutOutAnimation/AnimationPlayer.play("FadeToBlack");
	transition_sound.play();

func _on_animation_player_animation_finished(anim_name):
	get_tree().paused = false;
	if is_next_level:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level2/Level_2.tscn");
	elif is_main_menu:
		get_tree().change_scene_to_file("res://Main.tscn");
