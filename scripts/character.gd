extends Node2D

@onready var animated_sprite_2d = find_child("AnimatedSprite2D")
@export var hp = 100.0
@export var max_hp = 100.0
@export var speed = 300.0
@export var speed_scale = 1.0
@export var crit_chance = 15.0
@export var crit_damage = 150.0
@export var attack = 10.0
@export var damage_decrease = 0.0
@export var dodge = 10.0
@export var reload = 0.0
@export var invincibility_time = 3.0
@export var is_invincible = false
@export var invincible_effect_rate = 5
var invincibility_current_time = 0.0
var invincibility_blink = 0.0

func _process(delta):
	if is_invincible:
		# Halve opacity every uneven frame counts
		animated_sprite_2d.modulate.a = 0.5 if Engine.get_frames_drawn() % invincible_effect_rate > invincible_effect_rate / 2 else 1.0
	else:
		# But beware... if the last damage frame is not even,
		# you risk to leave your character half transparent!
		# Preferably do this when you set your flag back to false
		animated_sprite_2d.modulate.a = 1.0
	
	if(invincibility_current_time < 0):
		is_invincible = false
	else:
		invincibility_current_time -= delta

func receive_damage(value):
	if(is_invincible):
		return
	
	invincibility_current_time = invincibility_time
	is_invincible = true
	
	hp -= value
