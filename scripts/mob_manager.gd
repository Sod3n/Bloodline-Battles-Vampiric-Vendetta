extends Node

var _mobs : Array


var mobs : Array :
	get:
		_mobs = remove_invalid_objects(_mobs)
		return _mobs
	set(value):
		_mobs = value
		
func remove_invalid_objects(array: Array) -> Array:
	return array.filter(func(item):
		return item != null and is_instance_valid(item)
	)
