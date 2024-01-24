extends Control

@onready var confirm_sound = $ConfirmSFX;
@onready var transition_sound = $TransitionSFX;

@onready var time_label = $VBoxContainer/CenterContainer2/TimeLabel;
@onready var score_label = $VBoxContainer/CenterContainer3/ScoreLabel;

var time;
var score;

var is_next_level = false;
var is_main_menu = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$FrontTiles/NextLevel/Next_Level.grab_focus();
	
	score = get_node("/root/Main").get_score();
	time = get_node("/root/Main").get_time();
	
	print(str(score) + " " + str(time));


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

func update_labels():
	pass
