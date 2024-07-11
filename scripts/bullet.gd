extends "res://scripts/character_components/move.gd"

@export var lifetime : float = 10

var timer: Timer = Timer.new()

var damage : float

var bullet_owner : Character

func _ready():
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()
	
	
func _on_timeout():
	queue_free()


func _on_damage_area_2d_damage_dealed():
	queue_free()


func _on_damage_area_2d_on_enter(body):
	var dmg = Damage.new()
	dmg.value = bullet_owner.damage
	dmg.owner = bullet_owner
	dmg.target = body
	dmg.is_direct = false
	dmg.is_crit = bullet_owner.is_damage_was_crit	
	dmg.inflict()
