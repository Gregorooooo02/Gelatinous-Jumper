extends Node

var current_checkpoint : Checkpoint

var player : Player

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.position
		player.velocity = Vector2.ZERO
		print("Player respawned")
