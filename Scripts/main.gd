extends Node2D;
class_name World;

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN);


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
		
#func format_time(seconds):
	#var minutes = seconds // 60
	#var remaining_seconds = seconds % 60
	#return String().format("%02d:%02d", minutes, remaining_seconds)

func _on_timer_timeout():
	pass # Replace with function body.
