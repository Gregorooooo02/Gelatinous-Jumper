extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_overlapping_bodies():
		_on_body_entered(Player)

func _on_body_entered(body):
	if body is Player:
		get_node("/root/Main").reset_coins()
		GameManager.respawn_player()
