extends Node

var _mobs : Array


var mobs : Array :
	get:
		for i in _mobs.size():
			if not is_instance_valid(_mobs[i]):
				_mobs.erase(_mobs[i])
				i -= 1
			
		return _mobs
	set(value):
		_mobs = value
