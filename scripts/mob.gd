extends "res://scripts/character.gd"

@export var keep_distance = 500
@export var distance_spread = 100

@onready var player : Node2D
@onready var move_mob = $CharacterBody2D
@onready var sidestep = $CharacterBody2D/Sidestep


enum states {MOVE, STAY, SIDESTEP}
var state = states.MOVE

func _process(delta):
	var player_pos = player.global_position
	var vector = player_pos - move_mob.global_position
	var min_distance = keep_distance - distance_spread
	var max_distance = keep_distance + distance_spread  
	var length = vector.length()
	
	if sidestep.vector != Vector2.ZERO:
		state = states.SIDESTEP
	else:
		state = states.MOVE
	
	match state:
		states.MOVE:
			if abs(length - keep_distance) > 1:
				move_mob.vector = (vector.normalized() * sign(length - keep_distance) * speed * speed_scale)
			else:
				state = states.STAY
		states.STAY:
			move_mob.vector = Vector2.ZERO
			
			if length < min_distance or length > max_distance:
				state = states.MOVE
		states.SIDESTEP:
			move_mob.vector = sidestep.vector * speed * speed_scale
	
	
	
