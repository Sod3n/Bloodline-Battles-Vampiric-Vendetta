class_name UpgradeHealth
extends Upgrade

@export var value : float = 200
@export var _desription : String = "Increase max healph points."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.max_hp += value
	character.hp += value
