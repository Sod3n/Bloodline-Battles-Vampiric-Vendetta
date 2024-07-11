class_name UpgradeGermes
extends Upgrade

@export var value : float = 25
@export var _desription : String = "Increse speed while moving."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.speed_on_nonstop += value
