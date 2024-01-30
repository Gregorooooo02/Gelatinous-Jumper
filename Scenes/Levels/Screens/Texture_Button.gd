@tool
extends TextureButton

@export var text : String = "Text button";

@onready var select_sound = $SelectSFX;
var select_played = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_text();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		setup_text();

func setup_text():
	$RichTextLabel.text = "[center] %s [/center]" % [text];

func _on_mouse_entered():
	grab_focus();
	if !select_played:
		select_played = true;
		select_sound.play();

func _on_mouse_exited():
	select_played = false;

func _on_focus_entered():
	$RichTextLabel.modulate = Color(1, 1, 0, 1);
	

func _on_focus_exited():
	$RichTextLabel.modulate = Color(1, 1, 1, 1);
	select_played = false;
