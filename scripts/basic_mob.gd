extends "res://scripts/mob.gd"

@export var keep_distance = 500
@export var distance_spread = 100

@onready var player_body : Node2D
@onready var damage_area_2d = $CharacterBody2D/DamageArea2D

func _ready():
	body = $CharacterBody2D


enum states {MOVE, STAY, DIED}
var state = states.MOVE

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
			damage_area_2d.enable()
			animated_sprite_2d.play("run")
			
			if abs(length - keep_distance) > 1:
				velocity = (vector.normalized() * sign(length - keep_distance) * speed * speed_scale)
			else:
				state = states.STAY
		states.STAY:
			animated_sprite_2d.play("idle")
			
			velocity = Vector2.ZERO
			
			if (length < min_distance or length > max_distance) and not is_stunned:
				state = states.MOVE
			
		states.DIED:
			velocity = Vector2.ZERO
	
	body.vector = velocity
	
	rotate_sprite()
	
	
