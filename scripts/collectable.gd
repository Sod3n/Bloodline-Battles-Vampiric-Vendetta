class_name Collectable
extends Area2D

@onready var player_body : Node2D = Player.body
var player : Node = Player
var is_collecting = false
var is_collected = false
@export var speed = 900
@export var add_exp = 1

func _physics_process(delta):
	if is_collecting:
		if global_position.distance_to(player_body.global_position) < 20:
			
			global_position = player_body.global_position
			
			if not is_collected:
				collect()
				is_collected = true
		else:
			global_position += global_position.direction_to(player_body.global_position) * delta * speed

func collect():
	pass
