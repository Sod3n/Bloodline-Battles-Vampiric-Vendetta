extends "res://scripts/injecter.gd"
#
#var character:
	#get:
		#return $".."
#
#var injecter_flag = true
#
#
#func inject(node):
	#var nodes = get_all_children(node)
	#
	#for N in nodes:
		#_grab(N)
	#
	#for N in nodes:
		#_inject(N)
#
#func _inject(node):
	#if node == self:
		#return
#
	#if "character" in node:
		#node.character = character
