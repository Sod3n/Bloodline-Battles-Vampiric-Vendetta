class_name UpgradeHealth
extends Upgrade

var value : float = 200

func _init():
	description = "Increase max healph points."
	
func apply(character : Character) -> void:
	character.max_hp += value
	character.hp += value
