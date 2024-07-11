class_name Weapon
extends Node2D

@onready var damage_area = %DamageArea2D

var target: Node2D # change target for next attack
var weapon_owner : Character

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func get_rotation_between_neg_pi_and_pi(object_to_check: Node2D) -> float:
	# Get the raw rotation of the object
	var raw_rotation = object_to_check.rotation

	# Ensure the rotation is between -2*pi and 2*pi
	raw_rotation = fmod(raw_rotation, 2 * PI)

	# Normalize the rotation to be between -pi and pi
	var rotation_neg_pi_to_pi = raw_rotation
	if rotation_neg_pi_to_pi > PI:
		rotation_neg_pi_to_pi -= 2 * PI

	return rotation_neg_pi_to_pi


func _on_damage_area_2d_on_enter(body):
	var dmg = Damage.new()
	dmg.value = weapon_owner.damage
	dmg.owner = weapon_owner
	dmg.target = body
	dmg.is_direct = true
	dmg.is_crit = weapon_owner.is_damage_was_crit	
	dmg.inflict()
