extends "res://scripts/character_components/move.gd"

@export var lifetime : float = 10

var timer: Timer = Timer.new()

var damage : float

func _ready():
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()
	
	
func _on_timeout():
	queue_free()
	print("timeout")

func _on_damage_area_2d_damage_dealed():
	queue_free()


func _on_damage_area_2d_on_enter(body):
	body.receive_damage(damage)
