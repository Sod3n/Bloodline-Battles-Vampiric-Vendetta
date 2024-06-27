extends "res://scripts/collectables/collectable.gd"

@export var heal_percent = 20.0

func collect():
	player.hp += player.max_hp / 100 * heal_percent
	queue_free()

