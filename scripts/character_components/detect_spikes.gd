extends Area2D

@export var damage_value : float = 100
@export var cooldown : float = 1

@onready var current_time : float = cooldown

var _damaging : int = 0

func _physics_process(delta):
	current_time -= delta
	if _damaging > 0 and current_time <= 0:
		current_time = cooldown
		var damage = Damage.new()
		damage.value = damage_value
		damage.target = Global.player
		damage.is_direct = false
		damage.inflict()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_damaging += 1


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	_damaging -= 1
