extends Control

@onready var transition_player = $CutOutAnimation/AnimationPlayer;
@onready var menu_transition = $MainMenu/AnimationPlayer;
@onready var transition_sound = $MainMenu/TransitionSFX;

func _ready():
	$CutOutAnimation.visible = true;
	$CutOutAnimation/AnimationPlayer.play("FadeFromBlack");
	menu_transition.stop();


func _on_animation_player_animation_finished(anim_name):
	menu_transition.play("Start");


func _on_main_music_sfx_finished():
	$MainMenu/MainMusicSFX.play();
