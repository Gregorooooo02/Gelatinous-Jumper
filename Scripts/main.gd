extends Node2D;
class_name World;

var timer = 0
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+=delta
	update_timer_display()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit();

func update_timer_display():
	var time_label = get_node("../World/Camera2D/TimerDisplay")
	if time_label:
		time_label.text = str(int(timer)) + ":" + str(int((timer-int(timer))*1000))
		
func add_coins(amount):
	coins += amount
	update_coins_display()

func reset_coins():
	coins = 0
	update_coins_display()

func update_coins_display():
	var coin_label = get_node("../World/Camera2D/CoinDisplay")
	if coin_label:
		coin_label.text = str(coins*10)

func _on_timer_timeout():
	pass # Replace with function body.
