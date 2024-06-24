extends "res://scripts/move.gd"

@export var lifetime : float = 10

var timer: Timer = Timer.new()

var damage : float

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = lifetime
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timeout"))
	timer.start()
	
func _on_timeout():
	queue_free()
	pass

func _on_damage_area_2d_damage_dealed():
	queue_free()


func _on_damage_area_2d_on_enter(body):
	body.receive_damage(damage)
