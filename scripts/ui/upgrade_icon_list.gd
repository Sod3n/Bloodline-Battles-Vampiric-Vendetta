class_name UpgradeIconList
extends HBoxContainer

const UPGRADE_ICON = preload("res://scenes/ui/upgrade_icon.tscn")

var upgrades : Array[Upgrade]
var upgrade_icons : Array[UpgradeIcon]

func _ready():
	Global.upgrade_icon_list = self

func add_upgrade_icon(value: Upgrade):
	var upgrades_index = -1
	for upgrade in upgrades:
		if upgrade.description == value.description:
			upgrades_index = upgrades.find(upgrade)
	
	if upgrades_index == -1:
		upgrades.append(value)
		var upgrade_icon = UPGRADE_ICON.instantiate()
		upgrade_icon.texture = value.icon
		add_child(upgrade_icon)
		upgrade_icons.append(upgrade_icon)
	else:
		upgrade_icons[upgrades_index].increase_count()
