class_name Character
extends Node2D

@onready var animated_sprite_2d = find_child("AnimatedSprite2D")
@export var hp = 1000.0: set = set_hp

func set_hp(value):
	hp = value

@export var max_hp = 1000.0
@export var speed = 600.0
var speed_scale = 1.0
@export var crit_chance = 15.0
@export var crit_damage = 150.0
@export var attack = 10.0
@export var damage_decrease = 0.0
@export var dodge = 10.0
@export var reload = 1.0
@export var invincibility_time = 3.0
@export var is_invincible = false
@export var invincible_effect_rate = 8
var invincibility_current_time = 0.0
var invincibility_blink = 0.0
var is_stunned = false

var _stun_remaining_time = 0.0


var velocity : Vector2
var is_died = false
var body : Node2D

var is_damage_was_crit : bool = false

var damage:
	get:
		var dmg = attack
		var crit = randi_range(0, 100)
		is_damage_was_crit = crit < crit_chance
		if is_damage_was_crit:
			dmg *= crit_damage /100
		return dmg


func _process(delta):
	if is_invincible:
		# Halve opacity every uneven frame counts
		animated_sprite_2d.modulate.a = 0.7 if Engine.get_frames_drawn() % invincible_effect_rate > invincible_effect_rate / 2 else 1.0
	else:
		# But beware... if the last damage frame is not even,
		# you risk to leave your character half transparent!
		# Preferably do this when you set your flag back to false
		animated_sprite_2d.modulate.a = 1.0
	
	if(invincibility_current_time < 0):
		is_invincible = false
	else:
		invincibility_current_time -= delta
		
	if _stun_remaining_time < 0:
		is_stunned = false
	else:
		_stun_remaining_time -= delta

func receive_damage(value):
	if is_invincible or is_died:
		return
		
	invincibility_current_time = invincibility_time
	is_invincible = true
	
	hp -= value
	
	if hp <= 0:
		die()
	
func rotate_sprite():
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false

func die():
	is_died = true
	
func stun(value):
	_stun_remaining_time = value
	is_stunned = true

func can_act():
	return not is_stunned and not is_died


