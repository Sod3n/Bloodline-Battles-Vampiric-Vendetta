class_name UpgradeSpeed
extends Upgrade

@export var value_scale : float = 1.5
@export var _desription : String = "Increase speed."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.speed *= value_scale
