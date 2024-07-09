class_name UpgradeSpeed
extends Upgrade

@export var value : float = 1000
@export var _desription : String = "Increase speed."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.speed += value
