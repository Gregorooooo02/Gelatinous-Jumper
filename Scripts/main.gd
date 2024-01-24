extends Node2D;
class_name World;

@onready var transition = $CutOutAnimation/AnimationPlayer;
@onready var transition_sound = $TransitionSFX;

var timer = 0
var should_start = false;
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_coins();
	if transition:
		transition.play("FadeFromBlack");
		transition_sound.play();
	else:
		pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_start:
		timer+=delta
	update_timer_display()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit();

func update_timer_display():
	var time_label = get_node("../World/Camera2D/TimerDisplay")
	if time_label:
		time_label.text = "Time : " + str(int(timer)) + ":" + str(int((timer-int(timer))*1000))

func reset_coins():
	coins = 0
	update_coins_display()

func add_coins(amount):
	coins += amount
	update_coins_display()

func update_coins_display():
	var coin_label = get_node("../World/Camera2D/CoinDisplay")
	if coin_label:
		coin_label.text = "Score : " + str(coins * 10)

func _on_timer_timeout():
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name):
	should_start = true;
