class_name FocusedPresentation
extends AnimatedSprite2D

var tween : Tween

func _on_character_on_focus_changed(value: bool):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	if value:
		tween.tween_property(self, "modulate:a", 1, 0.3);
	else:
		tween.tween_property(self, "modulate:a", 0, 0.1);
