extends Node

var camera : Camera2D;
var player : Player;
var powerup_particles : CPUParticles2D;
var death_sfx : AudioStreamPlayer2D;

var is_gone : bool;
var spawned_nr = 0;
