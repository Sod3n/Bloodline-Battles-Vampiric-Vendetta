class_name UpgradeIcon
extends TextureRect

@onready var label = $Label
var upgrade : Upgrade:
	set(value):
		upgrade = value
		texture = upgrade.icon

var count : int = 1:
	set(value):
		count = value
		if count <= 1:
			label.text = ""
		else:
			label.text = str(count)

func _ready():
	count = 1

func increase_count():
	count = count + 1
