class_name UpgradeList
extends Node


var selected : bool = false
var upgrades : Array[Upgrade]
var available : bool :
	get:
		return get_available()

func get_available() -> bool:
	return true

func _ready():
	for upgrade in get_children_upgrades():
		upgrades.append(upgrade)

func get_children_upgrades():
	var array : Array
	for child in get_children():
		if child is Upgrade:
			array.push_front(child)
	return array
