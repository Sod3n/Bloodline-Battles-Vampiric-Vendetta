extends "res://scripts/collectable.gd"

@export var freeze_time = 5

var injecter : Node2D

func collect():
	for M in injecter.mobs:
		M.stun(freeze_time)
		print(M)
	
	queue_free()

