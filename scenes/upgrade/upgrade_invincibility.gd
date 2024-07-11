class_name UpgradeInvincibility
extends Upgrade

@export var value : float = 0.3
@export var _desription : String = "Increase invincibility time."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.invincibility_time += value
