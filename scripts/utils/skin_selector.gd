class_name SkinSelector
extends Node

@export var id : int = 0 :
	set(value):
		id = value
		for skin in skins:
			skin.hide()
		
		if skins.size() <= id:
			id = 0
		
		if id < 0:
			id = skins.size() - 1
		
		if Global.player and skins.size() > 0:
			Global.player.animated_sprite_2d = skins[id]
			Global.player.animated_sprite_2d.show()

var skins : Array[AnimatedSprite2D]



func _ready():
	skins = get_children_skins()

func get_children_skins() -> Array[AnimatedSprite2D]:
	var array : Array[AnimatedSprite2D]
	for child in get_children():
		if child is AnimatedSprite2D:
			array.push_front(child)
	return array
