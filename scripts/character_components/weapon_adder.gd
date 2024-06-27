extends Node2D

const PITCHFORK = preload("res://scenes/weapons/pitchfork.tscn")
const SHOVEL = preload("res://scenes/weapons/shovel.tscn")
@onready var weapon_slots : WeaponSlots = $"../WeaponSlots"
@onready var node_2d = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_slots.add_weapon(SHOVEL)
