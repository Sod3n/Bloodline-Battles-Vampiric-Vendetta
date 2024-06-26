class_name UpgradeCollectRadius
extends Upgrade

@export var scale_collect_radius : float = 1.5
@export var _desription : String = "Increase collect radius."

func _ready():
	description = _desription
	
func apply(character : BasicCharacter) -> void:
	character.collect_radius *= scale_collect_radius
