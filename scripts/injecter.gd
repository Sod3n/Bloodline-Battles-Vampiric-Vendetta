#extends Node
#
#@onready var player = $"../player"
#
#var _injecters : Array
#
#var injecters : Array :
	#get:
		#for object in _injecters:
			#if !is_instance_valid(object):
				#_injecters.erase(object)
				#print("erase")
		#return _injecters
	#set(value):
		#_injecters = value
#
#var _mobs : Array
#
#
#var mobs : Array :
	#get:
		#for object in _mobs:
			#if !is_instance_valid(object):
				#_mobs.erase(object)
				#print("erase")
		#return _mobs
	#set(value):
		#_mobs = value
#
#var is_injected = false
#
#func _ready():
	#inject(get_tree().get_root())
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
	#for I in _injecters:
		#print(I.character)
		#I.inject(I.character)
#
#func _grab(node):
	#if "is_mob_flag" in node:
		#mobs.append(node)
	#if "injecter_flag" in node and node != self:
		#injecters.append(node)
#
#func _inject(node):
	#if "player_body" in node:
			#node.player_body = player.get_node("CharacterBody2D")
		#
	#if "player" in node:
		#node.player = player
	#
	#if "injecter" in node:
		#node.injecter = self
#
#
#func get_all_children(node) -> Array:
	#var nodes : Array = []
#
	#for N in node.get_children():
		#if N.get_child_count() > 0:
			#nodes.append(N)
			#nodes.append_array(get_all_children(N))
		#else:
			#nodes.append(N)
	#return nodes
