class_name UpgradeWeaponList
extends UpgradeList

func get_available() -> bool:
	return Player.weapon_slots.is_there_free_slot
