extends Node2D

const PITCHFORK = preload("res://pitchfork.tscn")
const SHOVEL = preload("res://shovel.tscn")
@onready var weapon_slots = $"../WeaponSlots"
@onready var node_2d = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_slots.add_weapon(PITCHFORK)
	weapon_slots.add_weapon(PITCHFORK)
	weapon_slots.add_weapon(PITCHFORK)
	weapon_slots.add_weapon(PITCHFORK)
	weapon_slots.add_weapon(PITCHFORK)
	weapon_slots.add_weapon(PITCHFORK)
