extends Node

var upgrades : Array = []

func _init():
	upgrades.append(UpgradeHealth.new())
	upgrades.append(UpgradeHealth.new())
	upgrades.append(UpgradeHealth.new())
	upgrades.append(UpgradeHealth.new())
	upgrades.append(UpgradeHealth.new())

func get_random_upgrades(count : int) -> Array:
	var random_upgrades : Array = [] 
	for i in range(count):
		if upgrades.size() == 0:
			break
		var random_index = randi() % upgrades.size()
		var upgrade_instance = upgrades[random_index]
		upgrades.remove_at(random_index)
		random_upgrades.append(upgrade_instance)
	print("upg", upgrades.size())
	return random_upgrades

func return_upgrades(upgrade_list: Array):
	for upgrade in upgrade_list:
		upgrades.append(upgrade)
	print(upgrades.size())
