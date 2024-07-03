extends Control


const GAME = preload("res://scenes/utils/game.tscn")
@onready var savestate : ThothGameState = %Savestate
@onready var color_rect = $ColorRect


func _on_plus_skin_pressed():
	Global.player.skins.id += 1
	savestate.load_game_state()
	savestate.set_game_variables(Global.player.skins)
	savestate.save_game_state()


func _on_minus_skin_pressed():
	Global.player.skins.id -= 1
	savestate.load_game_state()
	savestate.set_game_variables(Global.player.skins)
	savestate.save_game_state()


func _on_start_pressed():
	# Начинаем анимацию затемнения
	fade_to_black()

func fade_to_black():
	var tween = create_tween()
	if tween:
		tween.tween_property(color_rect, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(_on_fade_completed)

func _on_fade_completed():
	# После завершения анимации затемнения сменяем сцену
	get_tree().change_scene_to_packed(GAME)
