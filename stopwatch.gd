extends Node2D

@onready var rich_text_label = $CanvasLayer/Control/RichTextLabel

var running = true
var elapsed_time = 0

func _process(delta):
	if running:
		elapsed_time += delta
		update_display()

func _ready():
	update_display()

func update_display():
	var minutes = int(elapsed_time / 60)
	var seconds = int(fmod(elapsed_time, 60))
	rich_text_label.bbcode_text = "[center]%02d:%02d[/center]" % [minutes, seconds]
