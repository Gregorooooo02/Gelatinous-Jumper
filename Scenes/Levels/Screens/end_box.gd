extends Area2D

func _on_body_entered(body):
	if body is Player:
		get_tree().paused = true;
		$"../SummaryScreen".show();
		$"../SummaryScreen/AnimationPlayer".play("Show");
