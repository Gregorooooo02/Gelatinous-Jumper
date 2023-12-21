extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var time = get_node("../../Main").timer
	$".".text = str(int(time)) + ":" + str(int((time-int(time))*1000))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
