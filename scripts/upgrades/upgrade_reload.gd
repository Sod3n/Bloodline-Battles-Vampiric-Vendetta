class_name UpgradeReload
extends Upgrade

@export var value_scale : float = 1.5
@export var _desription : String = "Decrease reload time."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.reload /= (1 / character.reload + value_scale)
