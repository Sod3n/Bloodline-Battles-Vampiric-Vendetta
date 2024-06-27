extends Area2D

signal damage_dealed
signal on_enter(body)

var collision_shape_2d : CollisionShape2D

func _ready():
	collision_shape_2d = find_child("CollisionShape2D")

func _on_body_entered(body):
	var char = body.get_owner()
	if char.has_method("receive_damage"):
		on_enter.emit(char)
		damage_dealed.emit()
		
func disable():
	collision_shape_2d.set_deferred("disabled", true)

func enable():
	collision_shape_2d.set_deferred("disabled", false)
