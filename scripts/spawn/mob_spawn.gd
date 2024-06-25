class_name MobSpawn
extends Node

const BASIC_MOB = preload("res://scenes/basic_mob.tscn")
const RANGE_MOB = preload("res://scenes/range_mob.tscn")
const FAST_MOB = preload("res://scenes/fast_mob.tscn")

enum Type {BASIC, RANGER, ASSASIN}

signal spawned

@export var type : Type = Type.BASIC 
@export var count : int = 1
@export var frequency : float = 5
@export var direction_priorities : Array[PointRandomizer.Priorities] \
= [PointRandomizer.Priorities.TOP, PointRandomizer.Priorities.RIGHT, \
PointRandomizer.Priorities.LEFT, PointRandomizer.Priorities.BOTTOM]

var timer := Timer.new()

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
		var mob = null
		match type:
			Type.BASIC:
				mob = BASIC_MOB.instantiate()
			Type.RANGER:
				mob = RANGE_MOB.instantiate()
			Type.ASSASIN:
				mob = FAST_MOB.instantiate()
		
		get_tree().root.add_child(mob)
		mob.owner = get_tree().root
		mob.body.global_position = spawn_position
	
	spawned.emit()
