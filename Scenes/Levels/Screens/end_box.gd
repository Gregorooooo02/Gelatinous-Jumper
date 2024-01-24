extends Area2D

@onready var time_label = $"../SummaryScreen/VBoxContainer/CenterContainer2/TimeLabel"
@onready var score_label = $"../SummaryScreen/VBoxContainer/CenterContainer3/ScoreLabel"

func _on_body_entered(body):
	if body is Player:
		get_tree().paused = true;
		$"../SummaryScreen".show();
		$"../SummaryScreen/AnimationPlayer".play("Show");
		
		time_label.text = get_node("/root/World/Camera2D/TimerDisplay").text;
		score_label.text = get_node("/root/World/Camera2D/CoinDisplay").text;
