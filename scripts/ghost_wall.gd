extends Node2D

@export var direction : Vector2 :
	set(value):
		for mob in mobs:
			mob.direction = value
		direction = value

var mobs : Array[GhostMob]

func _ready():
	mobs = get_children_ghost_mobs()

func get_children_ghost_mobs():
	var array : Array[GhostMob]
	for child in get_children():
		if child is GhostMob:
			array.push_front(child)
	return array
