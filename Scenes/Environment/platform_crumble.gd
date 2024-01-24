extends CharacterBody2D

@onready var crumble_animation = $AnimationPlayer;
@onready var collision_shape = $CollisionShape2D2

var timer_duration = 1  # Adjust this to set the time it takes for the platform to disappear (in seconds)
var timer_countdown = timer_duration
var is_disappearing = false
var original_visibility = true
var is_disabled = false

var timer_spawn = 2;
var countdown_spawn = timer_spawn;

func _ready():
	original_visibility = self.visible  # Save the initial visibility state

func _process(delta):
	if is_disappearing:
		timer_countdown -= delta
		if timer_countdown <= 0:
			self.visible = false
			collision_shape.disabled = true
			timer_countdown = timer_duration
			is_disappearing = false
		
	if not is_disappearing:
		countdown_spawn -= delta;
		if countdown_spawn <= 0:
			self.visible = true;
			collision_shape.disabled = false;
			countdown_spawn = timer_spawn;
	

# Signal when an area enters the platform
func _on_area_2d_body_entered(body):
	if body is Player and not is_disappearing:
		is_disappearing = true
		timer_countdown = timer_duration
		crumble_animation.play("crumbling");


func _on_area_2d_body_exited(body):
	if body is Player:
		timer_countdown = timer_duration
		is_disappearing = false;
		crumble_animation.play("RESET");
