extends Node2D

func _ready():
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		get_node("/root/Main").add_coins(1)
		queue_free();
