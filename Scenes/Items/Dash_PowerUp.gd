extends Node2D

@onready var animation_player = $AnimationPlayer;
@onready var sprite_2d = $Sprite2D

func _ready():
	animation_player.play("Basic");


func _on_area_2d_body_entered(body):
	if body is Player and body.has_method("change_to_dash"):
		body.change_to_dash();
		queue_free();
		
