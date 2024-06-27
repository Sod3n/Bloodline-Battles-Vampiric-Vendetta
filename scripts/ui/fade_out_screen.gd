extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready():
	fade_out()

func fade_out():
	var fade_out = create_tween()
	fade_out.tween_property(color_rect, "modulate:a", 0.0, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).from(1)
