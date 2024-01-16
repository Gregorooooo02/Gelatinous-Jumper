extends CharacterBody2D

var timer_duration = 2  # Adjust this to set the time it takes for the platform to disappear (in seconds)
var timer_countdown = timer_duration
var is_disappearing = false
var original_visibility = true
var is_disabled = false

var collision_shape: CollisionShape2D

func _ready():
	original_visibility = self.visible  # Save the initial visibility state
	collision_shape = $CollisionShape2D2

# Signal when an area enters the platform
func _on_body_entered(body):
	if body is Player and not is_disappearing:
		is_disappearing = true
		timer_countdown = timer_duration

# Signal when an area exits the platform
func _on_body_exited(body):
	if body is Player:
		timer_countdown = timer_duration
		is_disappearing = false

func _process(delta):
	if is_disappearing:
		timer_countdown -= delta

		if timer_countdown <= 0:
			self.visible = false
			collision_shape.disabled = true
			timer_countdown = timer_duration
			is_disappearing = false
