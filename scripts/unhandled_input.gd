extends Control

signal on_unhandled_input(event)

func _unhandled_input(event):
	on_unhandled_input.emit(event)
