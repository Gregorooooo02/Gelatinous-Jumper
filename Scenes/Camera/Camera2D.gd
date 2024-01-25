extends Camera2D;

var shake_amount = 0.0;
var default_offset = offset;
var pos_x;
var pos_y;

@onready var timer = $ShakeTimer;
@onready var tween = create_tween();

func _ready() -> void:
	Events.section_entered.connect(func(section):
		global_position = section.global_position;
	)
	set_process(true);
	Global.camera = self;
	randomize();

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount);
	
func shake(time, amount):
	timer.wait_time = time;
	shake_amount = amount;
	set_process(true);
	timer.start();
	

func _on_shake_timer_timeout():
	set_process(false);
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
