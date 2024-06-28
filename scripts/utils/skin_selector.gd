extends Node

@export var id : int = 0 :
	set(value):
		id = value
		for skin in skins:
			skin.hide()
		
		if Global.player and skins.size() > id:
			Global.player.animated_sprite_2d = skins[id]
			Global.player.animated_sprite_2d.show()

var skins : Array[AnimatedSprite2D]



func _ready():
	skins = get_children_skins()
	id = id
	print("id", id)

func get_children_skins() -> Array[AnimatedSprite2D]:
	var array : Array[AnimatedSprite2D]
	for child in get_children():
		if child is AnimatedSprite2D:
			array.push_front(child)
	return array
