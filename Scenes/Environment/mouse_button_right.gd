extends AnimatedSprite2D


func _ready():
	$AnimationPlayer.play("mouse_button_power");

func _process(delta):
	if Input.is_action_just_pressed("hold_right_button"):
		$Fade.play("fade_away");
		$Timer.start();


func _on_timer_timeout():
	queue_free();
