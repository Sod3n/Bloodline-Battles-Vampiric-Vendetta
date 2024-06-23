extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var character : Node2D

func _on_body_entered(body):
	var char = body.get_owner()
	if char.has_method("receive_damage"):
		print(character.name, character.damage)
		char.receive_damage(character.damage)
		
func disable():
	collision_shape_2d.set_deferred("disabled", true)

func enable():
	collision_shape_2d.set_deferred("disabled", false)
