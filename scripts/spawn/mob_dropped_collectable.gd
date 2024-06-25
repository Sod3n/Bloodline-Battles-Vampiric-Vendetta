class_name MobDroppedCollectable
extends Node

@export var spawn : MobSpawn
@export var collectables : Array[PackedScene]

var timer := Timer.new()

func _ready():
	add_child(timer)

func activate():
	timer.wait_time = randf_range(0, get_parent().duration)
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "assign"))
	timer.start()

func assign():
	print("assign")
	spawn.collectables = collectables
	
