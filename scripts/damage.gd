extends Area2D


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var char = area.get_owner()
	char.receive_damage(10)
