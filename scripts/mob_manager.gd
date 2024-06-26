class_name MobManager
extends Node

var _mobs : Array[Mob]


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
