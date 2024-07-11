class_name WeaponSlots
extends Node2D

@onready var slot_1 = $Slot1
@onready var slot_2 = $Slot2
@onready var slot_3 = $Slot3
@onready var slot_4 = $Slot4
@onready var slot_5 = $Slot5
@export var weapon_owner: Node2D

# Array to hold the weapon slots
var weapon_slots : Array[Node2D]

# Property to check if there is a free slot
var is_there_free_slot : bool :
	get:
		for slot in weapon_slots:
			if slot.get_child_count() == 0:
				return true
		return false
  

func _ready():
	weapon_slots.append(slot_1)
	weapon_slots.append(slot_2)
	weapon_slots.append(slot_3)
	weapon_slots.append(slot_4)
	weapon_slots.append(slot_5)

# Function to add a weapon to a free slot
func add_weapon(weapon_resouce: Resource) -> void:
	var weapon = weapon_resouce.instantiate()
	
	for slot in weapon_slots:
		if slot.get_child_count() == 0:
			weapon.weapon_owner = weapon_owner
			slot.add_child(weapon)
			weapon.position = Vector2.ZERO
			
			print("Weapon added to slot: ", slot.name)
			# Update the free slot status
			return
	print("No free slots available for weapon.")
