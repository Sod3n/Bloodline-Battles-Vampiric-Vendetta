class_name MobWave
extends Node

signal end

enum Event {}

@export var duration: float = 10

var timer := Timer.new()

var spawns : Array
var events : Array

func _ready():
	add_child(timer)
	spawns = get_children_spawns()
	events = get_children_events()

func start():
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "deactivate"))
	timer.start()
	activate()
	
func activate():
	for spawn in spawns:
		spawn.activate()
	
	for event in events:
		event.start()
	
func deactivate():
	for spawn in spawns:
		spawn.deactivate()
	end.emit()
	print("end")

func get_children_spawns():
	var array : Array
	for child in get_children():
		if child is MobSpawn:
			array.push_front(child)
	return array

func get_children_events():
	var array : Array
	for child in get_children():
		if child is MobWaveEvent:
			array.push_front(child)
	return array
