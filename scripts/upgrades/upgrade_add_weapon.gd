class_name UpgradeAddWeapon
extends Upgrade

@export var weapon : PackedScene
@export var _desription : String = "Give weapon."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.weapon_slots.add_weapon(weapon)
