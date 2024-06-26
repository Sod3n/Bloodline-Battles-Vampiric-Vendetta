class_name UpgradeCrit
extends Upgrade

@export var crit_chance : float = 5
@export var crit_damage : float = 25
@export var _desription : String = "Increase crits."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.crit_chance += crit_chance
	character.crit_damage += crit_damage
