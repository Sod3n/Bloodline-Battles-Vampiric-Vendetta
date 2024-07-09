class_name UpgradeAttack
extends Upgrade

@export var value_scale : float = 1.5
@export var _desription : String = "Increase attack."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.attack *= value_scale
