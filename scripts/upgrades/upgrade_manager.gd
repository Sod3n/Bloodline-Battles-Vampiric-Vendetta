extends Node

@export var selected_upgrade_chanse : int = 50

var selected_upgrades : Array[UpgradeList] = []
var not_selected_upgrades : Array[UpgradeList] = []

func _ready():
	for list in get_children_upgrade_lists():
		not_selected_upgrades.append(list)

func get_random_upgrades(count : int) -> Array[UpgradeList]:
	
	var random_upgrades : Array[UpgradeList] = [] 
	selected_upgrades = remove_not_available_upgrades(selected_upgrades)
	not_selected_upgrades = remove_not_available_upgrades(not_selected_upgrades)
	for i in range(count):
		if (randi_range(0, 100) < selected_upgrade_chanse and selected_upgrades.size() > 0) or not_selected_upgrades.size() == 0:
			if selected_upgrades.size() == 0:
				break
				
			var random_index = randi() % selected_upgrades.size()
			var upgrade_instance = selected_upgrades[random_index]
			
			random_upgrades.append(upgrade_instance)
			selected_upgrades.remove_at(random_index)
		else:
			print("size ", not_selected_upgrades.size())
			if not_selected_upgrades.size() == 0:
				break
			var random_index = randi() % not_selected_upgrades.size()
			var upgrade_instance = not_selected_upgrades[random_index]
			
			random_upgrades.append(upgrade_instance)
			not_selected_upgrades.remove_at(random_index)
		
	return random_upgrades

func return_upgrades(upgrade_list: Array[UpgradeList]):
	
	for upgrade in upgrade_list:
		if upgrade.upgrades.size() <= 0 :
			continue
		
		if upgrade.selected:
			selected_upgrades.append(upgrade)
		else:
			not_selected_upgrades.append(upgrade)
	

func get_children_upgrade_lists():
	var array : Array
	for child in get_children():
		if child is UpgradeList:
			array.push_front(child)
	return array

func remove_not_available_upgrades(array: Array) -> Array:
	return array.filter(func(item):
		print("item.available ", item.available)
		return item.available
	)
