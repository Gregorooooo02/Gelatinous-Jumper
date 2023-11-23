extends Area2D

@onready var end_screen = $"../End_Screen";
@onready var label = $"../End_Screen/Label";

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_Area2D_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body is Player:
		label.visible = true;
