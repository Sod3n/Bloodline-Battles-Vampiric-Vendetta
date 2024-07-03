extends Control
@onready var win = $"../Control/Win"
const MAIN_MENU = preload("res://scenes/utils/main_menu.tscn")

func _unhandled_input(event):
	print(event)
	if event is InputEventMouseMotion:
		return
	
	if win.done:
		get_tree().paused = false
		get_tree().change_scene_to_packed(MAIN_MENU)



func _on_pressed():
	if win.done:
		get_tree().paused = false
		get_tree().change_scene_to_packed(MAIN_MENU)
