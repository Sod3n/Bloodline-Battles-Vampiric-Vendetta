extends Area2D

@export var damage : float = 100
@export var cooldown : float = 1

@onready var current_time : float = cooldown

var _is_damaging : bool = false

func _physics_process(delta):
	current_time -= delta
	if _is_damaging and current_time <= 0:
		current_time = cooldown
		Global.player.receive_damage(damage)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_is_damaging = true


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	_is_damaging = false
