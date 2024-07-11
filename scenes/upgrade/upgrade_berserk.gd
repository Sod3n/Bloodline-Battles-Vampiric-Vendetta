class_name UpgradeBerserk
extends Upgrade

@export var value : float = 0.5
@export var _desription : String = "Increase damage by lost health."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.damage_scale_by_lost_health += value
