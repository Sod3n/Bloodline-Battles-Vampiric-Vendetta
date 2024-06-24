extends CanvasLayer

signal deactivated

@onready var button_1 = $HBoxContainer/VBoxContainer/Button1
@onready var button_2 = $HBoxContainer/VBoxContainer/Button2
@onready var button_3 = $HBoxContainer/VBoxContainer/Button3

var upgrades : Array

func _ready():
	deactivate()

func activate():
	self.show()
	upgrades = UpgradeManager.get_random_upgrades(3)
	_set_button_text(button_1, _get_at(upgrades, 0))
	_set_button_text(button_2, _get_at(upgrades, 1))
	_set_button_text(button_3, _get_at(upgrades, 2))
	button_1.grab_focus()
	get_tree().paused = true

func deactivate():
	self.hide()
	_hide_all()
	get_tree().paused = false
	deactivated.emit()

func _set_button_text(button: Button, upgrade: Upgrade):
	if upgrade and button:
		button.text = upgrade.description
		button.show()

func _hide_all():
	button_1.hide()
	button_2.hide()
	button_3.hide()

func _on_button_pressed(button_index):
	upgrades[button_index].apply(Player)
	upgrades.remove_at(button_index)
	UpgradeManager.return_upgrades(upgrades)
	deactivate()

func _on_button_1_pressed():
	_on_button_pressed(0)


func _on_button_2_pressed():
	_on_button_pressed(1)


func _on_button_3_pressed():
	_on_button_pressed(2)

func _get_at(array : Array, index : int):
	if index <= array.size()-1:
		return array[index]
	return null
