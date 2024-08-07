class_name GameOverScreen
extends CanvasLayer

const GAME = preload("res://scenes/utils/game.tscn")

@onready var game_over_label = $Control/RichTextLabel
@onready var overlay = $Control/ColorRect
@onready var tip = $Control/RichTextLabel2
@onready var current_map = get_tree().current_scene
@onready var overlay_2 = $Control/CanvasLayer/ColorRect2

var _is_main_info_showed = false
var _reloaded = false

func _ready():
	overlay.hide()
	game_over_label.hide()
	tip.hide()

func show_game_over():
	await get_tree().create_timer(3.0).timeout
	var fade_in = create_tween()
	fade_in.tween_property(overlay, "modulate:a", 1.0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).from(0)
	fade_in.tween_callback(Callable(self, "_on_fade_in_completed"))
	overlay.show()

func _on_fade_in_completed():
	# Можно добавить дополнительные анимации или действия после завершения затемнения
	# Например, анимацию для появления надписи "Game Over"
	var scale_in = create_tween()
	game_over_label.scale = Vector2.ZERO
	scale_in.tween_property(game_over_label, "scale", Vector2(1, 1), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).from(Vector2.ZERO)
	game_over_label.show()
	scale_in.tween_callback(Callable(self, "_on_scale_in_completed"))

func _on_scale_in_completed():
	_is_main_info_showed = true
	await get_tree().create_timer(5.0).timeout
	var fade_in = create_tween()
	tip.modulate.a = 0
	fade_in.tween_property(tip, "modulate:a", 1.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).from(0)
	tip.show()

func _input(event):
	if event is InputEventMouseMotion:
		return
	
	if _is_main_info_showed and not _reloaded:
		var fade_in = create_tween()
		fade_in.tween_property(overlay_2, "modulate:a", 1.0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).from(0)
		_reloaded = true
		await fade_in.finished
		get_tree().reload_current_scene()
		
