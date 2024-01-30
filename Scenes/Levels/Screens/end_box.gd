extends Area2D

@onready var time_label = $"../SummaryScreen/VBoxContainer/CenterContainer2/TimeLabel";
@onready var score_label = $"../SummaryScreen/VBoxContainer/CenterContainer3/ScoreLabel";
@onready var timer = $"../SummaryScreen/Timer";

func _on_body_entered(body):
	timer.start();
	if timer.time_left == 3.0:
		$"../SummaryScreen/Fireworks".emitting = true;
		$"../SummaryScreen/FireworkSFX".play();
	
	if timer.time_left == 2.5:
		$"../SummaryScreen/Fireworks2".emitting = true;
		$"../SummaryScreen/FireworkSFX".play();
	
	if timer.time_left == 2.0:
		$"../SummaryScreen/Fireworks3".emitting = true;
		$"../SummaryScreen/FireworkSFX".play();
	
	if body is Player:
		get_tree().paused = true;
		$"../SummaryScreen".show();
		$"../SummaryScreen/AnimationPlayer".play("Show");
		
		get_node("/root/World/Camera2D/TimerDisplay").visible = false;
		get_node("/root/World/Camera2D/CoinDisplay").visible = false;
		
		time_label.text = get_node("/root/World/Camera2D/TimerDisplay").text;
		score_label.text = get_node("/root/World/Camera2D/CoinDisplay").text;
