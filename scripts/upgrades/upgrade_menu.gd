class_name UpgradeMenu
extends CanvasLayer

signal deactivated

@onready var button_1 = $HBoxContainer/VBoxContainer/Button1
@onready var button_2 = $HBoxContainer/VBoxContainer/Button2
@onready var button_3 = $HBoxContainer/VBoxContainer/Button3
@onready var rich_text_label_1 = $HBoxContainer/VBoxContainer/Button1/RichTextLabel
@onready var rich_text_label_2 = $HBoxContainer/VBoxContainer/Button2/RichTextLabel
@onready var rich_text_label_3 = $HBoxContainer/VBoxContainer/Button3/RichTextLabel

var upgrade_lists : Array[UpgradeList]

func _init():
	Global.upgrade_menu = self

func _ready():
	deactivate()

func activate():
	self.show()
	upgrade_lists = Global.upgrade_manager.get_random_upgrades(3)
	_set_button_text(button_1, rich_text_label_1, _get_at(upgrade_lists, 0))
	_set_button_text(button_2, rich_text_label_2, _get_at(upgrade_lists, 1))
	_set_button_text(button_3, rich_text_label_3, _get_at(upgrade_lists, 2))
	button_1.grab_focus()
	get_tree().paused = true
	if upgrade_lists.size() <= 0:
		deactivate()

func deactivate():
	self.hide()
	_hide_all()
	get_tree().paused = false
	deactivated.emit()

func _set_button_text(button: Button, text : Label, upgrade_list: UpgradeList):
	if upgrade_list and button:
		text.text = upgrade_list.upgrades.front().description
		button.show()

func _hide_all():
	button_1.hide()
	button_2.hide()
	button_3.hide()

func _on_button_pressed(button_index):
	await get_tree().create_timer(0.2).timeout
	var upgrade = upgrade_lists[button_index].upgrades.pop_front()
	if not upgrade:
		return
	upgrade_lists[button_index].selected = true
	upgrade.apply(Global.player)
	Global.upgrade_manager.return_upgrades(upgrade_lists)
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
