extends Area2D

@export var damage : float = 100

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	Global.player.receive_damage(damage)
