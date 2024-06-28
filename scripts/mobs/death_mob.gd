extends "res://scripts/mobs/mob.gd"

const BULLET_LARGE = preload("res://scenes/weapons/bullet_large.tscn")

@onready var shooter : Shooter = %Shooter

@export_group("Circle attack")
@export_range(4, 100, 2) var number_of_bullets : int
@export var bullet_ref : ShooterRay

@export_group("Contact attack")
@export var stun_time : float = 1
@export var cooldown_time : float = 2

@onready var fake_target = %FakeTarget
@onready var damage_area_2d = $CharacterBody2D/DamageArea2D

func _ready():
	body = $CharacterBody2D
	set_up_circle_attack()

func set_up_circle_attack():
	shooter.bullet = BULLET_LARGE
	shooter.target = fake_target
	
	var deviation_step = 180 / (number_of_bullets / 2)
	
	var bullet = bullet_ref.duplicate()
	bullet.deviation = 0
	shooter.rays.append(bullet)
	bullet = bullet_ref.duplicate()
	bullet.deviation = 180
	shooter.rays.append(bullet)
	
	for i in range(1, (number_of_bullets / 2)):
		bullet = bullet_ref.duplicate()
		var bullet_2 = bullet_ref.duplicate()
		bullet.deviation = deviation_step * i
		bullet_2.deviation = -deviation_step * i
		shooter.rays.append(bullet)
		shooter.rays.append(bullet_2)
	shooter.initialize()



func _on_damage_area_2d_on_enter(body: Character):
	body.receive_damage(damage)
	body.stun(stun_time)
	damage_area_2d.disable()
	get_tree().create_timer(cooldown_time * reload).timeout.connect(Callable(self, "_enable_damage_area"))


func _enable_damage_area():
	damage_area_2d.enable()
	print("damage_area_2d")
