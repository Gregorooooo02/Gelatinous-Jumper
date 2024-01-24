extends Node2D

@onready var sprite_animation = $Sprite2D;

func _ready():
	sprite_animation.play("default");


func _on_area_2d_body_entered(body):
	if body is Player:
		get_node("/root/Main").add_coins(1)
		queue_free();
