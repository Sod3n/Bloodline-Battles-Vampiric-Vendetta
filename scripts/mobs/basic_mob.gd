class_name BasicMob
extends "res://scripts/mobs/mob.gd"

@export var keep_distance : float = 500
@export var distance_spread : float  = 100

func _ready():
	super()
	body = $CharacterBody2D

enum states {MOVE, STAY, DIED}
var state = states.MOVE
var _actual_velocity : Vector2
var _last_point : Vector2

func _process(delta):
	super(delta)
	var player_pos = player_body.global_position
	var vector = player_pos - body.global_position
	var min_distance = keep_distance - distance_spread
	var max_distance = keep_distance + distance_spread  
	var length = vector.length()
	
	if is_stunned:
		damage_area_2d.disable()
		state = states.STAY
	
	if is_died:
		damage_area_2d.disable()
		state = states.DIED
	
	
	match state:
		states.MOVE:
			if not keep_distance_with_player(keep_distance, distance_spread):
				state = states.STAY
			
			if _actual_velocity.length() <= 1:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		states.STAY:
			animated_sprite_2d.play("idle")
			
			velocity = Vector2.ZERO
			
			if (length < min_distance or length > max_distance):
				state = states.MOVE
			
		states.DIED:
			velocity = Vector2.ZERO
	
	body.vector = velocity
	
	rotate_sprite()

func _physics_process(delta):
	_actual_velocity = body.global_position - _last_point
	_last_point = body.global_position
