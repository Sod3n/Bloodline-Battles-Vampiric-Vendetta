extends "res://scripts/collectable.gd"

@export var freeze_time = 5

var mob_manager : Node = MobManager

func collect():
	for M in mob_manager.mobs:
		M.stun(freeze_time)
		print(M)
	
	queue_free()

