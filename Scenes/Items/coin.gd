extends Node2D

@onready var sprite_animation = $Sprite2D;
@onready var collision = $Area2D/CollisionShape2D;
@onready var area = $Area2D;
@onready var particles = $CPUParticles2D;
@onready var timer = $Timer;
@onready var sfx = $PickupSFX;

func _ready():
	sprite_animation.play("default");


func _on_area_2d_body_entered(body):
	if body is Player:
		get_node("/root/Main").add_coins(1)
		sfx.play();
		sprite_animation.visible = false;
		collision.disabled = true;
		particles.emitting = true;
		timer.start();


func _on_timer_timeout():
	queue_free();
