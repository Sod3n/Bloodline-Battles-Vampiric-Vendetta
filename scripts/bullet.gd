extends "res://scripts/character_components/move.gd"

@export var lifetime : float = 10

var timer: Timer = Timer.new()

var damage : float

var bullet_owner : Character

var dmg = Damage.new()

func _ready():
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()
	dmg.value = bullet_owner.damage
	dmg.owner = bullet_owner
	dmg.is_direct = false
	dmg.is_crit = bullet_owner.is_damage_was_crit	
	
	
func _on_timeout():
	queue_free()


func _on_damage_area_2d_damage_dealed():
	queue_free()


func _on_damage_area_2d_on_enter(body):
	dmg.target = body
	dmg.inflict()
