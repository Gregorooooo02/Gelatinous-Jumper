extends AnimatedSprite2D


func _ready():
	$AnimationPlayer.play("mouse_movement")

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		$Fade.play("fade_away");
		$Timer.start();


func _on_timer_timeout():
	queue_free();
