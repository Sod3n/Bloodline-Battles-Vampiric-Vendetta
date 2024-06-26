class_name UpgradeAttack
extends Upgrade

@export var value : float = 100
@export var _desription : String = "Increase attack."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.attack += value
