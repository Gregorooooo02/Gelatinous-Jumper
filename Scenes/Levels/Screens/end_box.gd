extends Area2D

func _on_body_entered(body):
	if body is Player:
		get_tree().paused = true;
		$"../SummaryScreen".show();
		$"../SummaryScreen/AnimationPlayer".play("Show");
		$"../SummaryScreen/TimeLabel".text = get_node("/root/World/Camera2D/TimerDisplay").text
		$"../SummaryScreen/CoinLabel".text = get_node("/root/World/Camera2D/CoinDisplay").text
