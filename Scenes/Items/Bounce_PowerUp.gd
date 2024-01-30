extends Node2D;
class_name Bounce_PowerUp;

@onready var animation_player = $AnimationPlayer;
@onready var sprite_2d = $Sprite2D;
@onready var input_sprite = $InputSprite;

var can_change = false;

func _ready():
	animation_player.play("Basic");
	input_sprite.play("default");

func _process(delta):
	if can_change and Input.is_action_just_pressed("middle_click"):
		_change(Global.player);
		can_change = false;

func _on_area_2d_body_entered(body):
	if body is Player and body.has_method("change_to_bounce"):
		animation_player.play("spacebar_appear");
		can_change = true;


func _on_area_2d_body_exited(body):
	if body is Player and body.has_method("change_to_bounce"):
		animation_player.play("spacebar_dissappear");
		can_change = false;

func _change(body):
	Global.powerup_particles.emitting = true;
	Global.is_gone = true;
	body.change_to_bounce();
	queue_free();
