extends "res://scripts/character.gd"

@export var distance_to_around = 500
@export var around_max_time = 7

@onready var move_mob = $CharacterBody2D

var player : Node2D

enum states {RUN, AWAY, AROUND}
var state = states.RUN

var around_left_time = 0
var around_angle = 0

var away_vector_normalized : Vector2

func _process(delta):
	move_mob.vector = Vector2.ZERO
	
	var player_pos = player.global_position
	var vector = player_pos - move_mob.global_position
	var length = vector.length()
	match state:
		states.RUN:
			if length > 200:
				move_mob.vector = vector.normalized() * speed * speed_scale
			else:
				away_vector_normalized = vector.normalized()
				state = states.AWAY
		states.AWAY:
			if length < distance_to_around:
				move_mob.vector = away_vector_normalized * speed * speed_scale
			else:
				state = states.AROUND
				around_left_time = randi_range(3, around_max_time)
				around_angle = (-vector - Vector2.RIGHT).angle()
		states.AROUND:
			around_left_time -= delta
			if around_left_time < 0:
				state = states.RUN
			
			around_angle += speed * delta * 0.002 * speed_scale
			
			if(around_angle > 360):
				around_angle = 0
				
			var x_pos = cos(around_angle)
			var y_pos = sin(around_angle)
			
			var new_pos = Vector2(x_pos * distance_to_around, y_pos * distance_to_around) + player_pos
			
			move_mob.global_position = new_pos
