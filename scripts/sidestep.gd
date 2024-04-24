extends Node2D
@onready var character_body_2d = $".."

var count = 0
var vector = Vector2.ZERO
var move_node : Node2D

func _process(delta):
	if move_node == null:
		return
		
	var move_vector = move_node.vector
	var body_pos = move_node.global_position
	var from_body_vector = global_position - body_pos
	
	var sign = sign(move_vector.angle_to(from_body_vector))
	move_vector = -move_vector
	move_vector = move_vector.rotated(60 * sign)
	vector = move_vector.normalized()
	print(vector)

func _on_area_2d_body_entered(body):
	var move = body
	
	if(move == character_body_2d):
		return
	
	if(!move):
		return
	
	if(not "vector" in move):
		return
	
	print(move.name)
	
	
	move_node = move
	count += 1


func _on_area_2d_body_exited(body):
	count -= 1
	
	if count == 0:
		vector = Vector2.ZERO
		move_node = null
