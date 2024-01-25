extends Node

var current_checkpoint : Checkpoint;
var player : Player;
var death_sound: AudioStreamPlayer2D;

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.position;
		player.velocity = Vector2.ZERO;
		print("Player respawned");
		Global.camera.shake(0.1, 4);
		Global.death_sfx.pitch_scale = randf_range(0.8, 1.5);
		Global.death_sfx.play();
