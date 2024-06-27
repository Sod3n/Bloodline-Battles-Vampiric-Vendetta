extends "res://scripts/mobs/mob.gd"

@onready var player_body : Node2D = Global.player.body

@export var content : Array[PackedScene]
@export var open_distance : float = 200

func _ready():
	super()
	body = $CharacterBody2D

func _process(delta):
	super(delta)
	var vector = Global.player.body.global_position - body.global_position
	var length = vector.length()
	if length <= open_distance and not is_died:
		die()
	
func die():
	super()
	for item in content:
		var node := item.instantiate()
		get_tree().current_scene.add_child(node)
		node.global_position = body.global_position
		
