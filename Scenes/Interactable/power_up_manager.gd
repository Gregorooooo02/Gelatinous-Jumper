extends Node2D

signal spawned(spawn);

@export var spawnling_scene : PackedScene;
var can_spawn;

func _ready():
	_spawn();
	Global.is_gone = false;
	
func _process(delta):
	if Global.is_gone:
		_spawn();
		Global.is_gone = false;

func _spawn():
	var spawnling = spawnling_scene.instantiate();
	add_child(spawnling);
	spawnling.global_position = global_position;	
	emit_signal("spawned", spawnling);
	return spawnling;
