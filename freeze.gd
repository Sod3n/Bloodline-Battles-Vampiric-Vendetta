extends "res://scripts/collectable.gd"

@export var freeze_time = 5

@onready var mob_manager : MobManager = Global.mob_manager

var freeze_remaining_time = 0

func collect():
	for M in mob_manager.mobs:
		M.stun(freeze_time)
	
	freeze_remaining_time = freeze_time
	hide()

func _physics_process(delta):
	super(delta)
	for M in mob_manager.mobs:
		M.stun(freeze_remaining_time)
	
	freeze_remaining_time -= delta
	
	if freeze_remaining_time <= 0 and is_collected:
		queue_free()
