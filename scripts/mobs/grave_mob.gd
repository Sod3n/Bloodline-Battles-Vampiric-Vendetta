extends "res://scripts/mobs/mob.gd"

var shoot_timer: Timer = Timer.new()
var relief_timer: Timer = Timer.new()


@export var relief_time : float = 2
@export var shoot_time : float = 0.75 * 2
@export var shooters : Array[Shooter]

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	body = $CharacterBody2D
	add_child(shoot_timer)
	add_child(relief_timer)
	shoot_timer.timeout.connect(Callable(self, "relief"))
	relief_timer.timeout.connect(Callable(self, "shoot"))
	await get_tree().create_timer(1).timeout
	shoot()

func shoot():
	shoot_timer.wait_time = shoot_time
	shoot_timer.one_shot = true
	shoot_timer.start()
	for shooter in shooters:
		shooter.activate()

func relief():
	relief_timer.wait_time = relief_time
	relief_timer.one_shot = true
	relief_timer.start()
	for shooter in shooters:
		shooter.deactivate()
