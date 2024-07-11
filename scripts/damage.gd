class_name Damage

var value: float
var owner: Character
var is_direct: bool = true
var is_crit: bool = false
var target: Character

static func create(value: float, owner: Character, target: Character, is_direct: bool = true, is_crit = false) -> Damage:
	var instance = Damage.new()
	instance.value = value
	instance.owner = owner
	instance.is_direct = is_direct
	instance.is_crit = is_crit
	instance.target = target
	return instance

func inflict():
	if value <= 0:
		return
	
	var dmg_inflicted = target.receive_damage(self) 
	if dmg_inflicted and owner is BasicCharacter:
		GlobalDamageNumbersManager.show_damage(self)
