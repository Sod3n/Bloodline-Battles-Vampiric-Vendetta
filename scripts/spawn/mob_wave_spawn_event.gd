class_name MobWaveSpawnEvent
extends MobWaveEvent

var spawns : Array
var collectables : Array

func _ready():
	spawns = get_children_spawns()
	collectables = get_children_collectables()

func start():
	for spawn in spawns:
		spawn.activate()
		spawn.spawned.connect(Callable(self, "stop"))
	

func stop():
	for spawn in spawns:
		spawn.deactivate()

func get_children_spawns():
	var array : Array
	for child in get_children():
		if child is MobSpawn:
			array.push_front(child)
	return array

func get_children_collectables():
	var array : Array
	for child in get_children():
		if child is MobDroppedCollectable:
			array.push_front(child)
	return array
