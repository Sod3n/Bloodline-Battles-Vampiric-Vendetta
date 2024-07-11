class_name UpgradeReturnDamage
extends Upgrade

@export var value : float = 20
@export var _desription : String = "Return 20% of received damage to enemy."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.return_off_received_damage += value
