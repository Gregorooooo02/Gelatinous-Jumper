extends Camera2D;

func _ready() -> void:
	Events.section_entered.connect(func(section):
		global_position = section.global_position;
	)
