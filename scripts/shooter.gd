extends Node

const BULLET = preload("res://scenes/bullet.tscn")

@export var frequency : float = 2
@export var bullet_speed : float = 500
@onready var range_mob = $"../.."

var timer: Timer = Timer.new()
@onready var player_body = Player.body

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.wait_time = frequency
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timeout"))
	timer.start()

func _on_timeout():
	if not range_mob.can_act():
		return
	
	var instance = BULLET.instantiate()
	instance.vector = (player_body.global_position - self.global_position).normalized() * bullet_speed
	instance.global_position = self.global_position
	instance.damage = range_mob.damage
	get_tree().root.add_child(instance)
	pass
