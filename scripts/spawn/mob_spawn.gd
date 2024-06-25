class_name MobSpawn
extends Node

signal spawned

@export var type : PackedScene = preload("res://scenes/basic_mob.tscn")
@export var count : int = 1
@export var frequency : float = 5
@export var direction_priorities : Array[PointRandomizer.Priorities] \
= [PointRandomizer.Priorities.TOP, PointRandomizer.Priorities.RIGHT, \
PointRandomizer.Priorities.LEFT, PointRandomizer.Priorities.BOTTOM]

var timer := Timer.new()

var collectables : Array

func _ready():
	add_child(timer)

func activate():
	timer.wait_time = frequency
	timer.one_shot = false
	timer.timeout.connect(Callable(self, "spawn_mobs"))
	timer.start()

func deactivate():
	timer.stop()

func spawn_mobs():
	for i in count:
		var spawn_position = Global.point_randomizer.generate_random_point_for_spawn(direction_priorities)
		var mob = type
		
		get_tree().root.add_child(mob)
		mob.owner = get_tree().root
		mob.body.global_position = spawn_position
		
		if collectables.size() >= count - i:
			mob.dropped_collectable = collectables.pop_front()
			print("size difference, adding")
		elif randi_range(0, 100) >= 50:
			mob.dropped_collectable = collectables.pop_front()
		
	
	spawned.emit()
