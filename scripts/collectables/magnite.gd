extends "res://scripts/collectables/collectable.gd"

@export var time = 5
@onready var timer = $Timer

var _base_radius : float
var _remain_time : float
var _collected = false

func collect():
	_base_radius = player.collect_radius
	player.collect_radius = 10000000
	timer.wait_time = time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	player.collect_radius = _base_radius
	queue_free()
