class_name MobManager
extends Node

var _mobs : Array[Mob]

var dead_mobs_count : int = 0

var mobs : Array[Mob] :
	get:
		_mobs = remove_invalid_objects(_mobs)
		return _mobs
	set(value):
		_mobs = value
		
func remove_invalid_objects(array: Array[Mob]) -> Array[Mob]:
	return array.filter(func(item):
		return item != null and is_instance_valid(item)
	)

func kill_all():
	for mob in mobs:
		mob.die()

func _init():
	Global.mob_manager = self
