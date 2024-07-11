class_name UpgradeFocus
extends Upgrade

@export var value : float = 10
@export var _desription : String = "Decrease received damage."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.damage_decrease += value
