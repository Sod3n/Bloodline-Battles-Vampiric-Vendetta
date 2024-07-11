extends Control

@export var target: Node2D
@export var margin: float = 10.0  # Расстояние от краев экрана

func _process(delta: float) -> void:
	if not target:
		return
	
	var viewport := get_viewport()
	var camera := viewport.get_camera_2d()
	var viewport_size := viewport.get_visible_rect().size
	var root = get_tree().root; 
	var screen_pos = target.global_position - (camera.get_screen_center_position() - viewport_size / 2)
	if viewport.get_visible_rect().has_point(screen_pos):
		hide()
	else:
		show()
		# Ограничение позиции маркера с учетом margin
		screen_pos.x = clamp(screen_pos.x, margin, viewport_size.x - margin)
		screen_pos.y = clamp(screen_pos.y, margin, viewport_size.y - margin)
		position = screen_pos

