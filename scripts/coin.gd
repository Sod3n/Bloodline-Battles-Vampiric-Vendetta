extends "res://scripts/collectable.gd"

@export var scale_exp_chance = 1
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func collect():
	var exp = add_exp
	
	var scale_rand = randi_range(0, 100)
	if scale_rand <= scale_exp_chance:
		exp *= 2
		audio_stream_player_2d.play()
	else:
		get_owner().queue_free()
		
	player.exp += exp
	audio_stream_player_2d.finished.connect(_on_sound_finished)
	get_owner().hide()

func _on_sound_finished():
	get_owner().queue_free()
