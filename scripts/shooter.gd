class_name Shooter
extends Node


const BULLET = preload("res://scenes/bullet.tscn")

@export var frequency : float = 2
@export var bullet_speed : float = 500
@export var bullet_lifetime : float = 10
@export var deviation : float = 0
@onready var range_mob = $"../.."

var timer: Timer = Timer.new()
@onready var player_body = Player.body

var active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.timeout.connect(Callable(self, "_on_timeout"))
	timer.wait_time = frequency
	timer.one_shot = false

func _on_timeout():
	if not range_mob.can_act() or active:
		return
	
	var instance = BULLET.instantiate()
	instance.vector = (player_body.global_position - self.global_position).normalized().rotated(deg_to_rad(deviation))
	instance.vector *= bullet_speed
	instance.global_position = self.global_position
	instance.damage = range_mob.damage
	instance.lifetime = bullet_lifetime
	get_tree().root.add_child(instance)
	pass

func activate():
	timer.start()
	_on_timeout()
	
func deactivate():
	timer.stop()
	print("timer stop")
