extends Node2D;

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.section_entered.emit(self);
