extends "res://scripts/mob.gd"

@export var distance_to_around = 500
@export var around_max_time = 7
@onready var damage_area_2d = $CharacterBody2D/DamageArea2D

func _ready():
	body = $CharacterBody2D

var player_body : Node2D

enum states {RUN, AWAY, AROUND, DIED, STAY}
var state = states.RUN

var around_left_time = 0
var around_angle = 0

var away_vector_normalized : Vector2

func _process(delta):
	super(delta)
	
	velocity = Vector2.ZERO
	
	var player_pos = player_body.global_position
	var vector = player_pos - body.global_position
	var length = vector.length()
	
	
	if is_stunned:
		state = states.STAY
		damage_area_2d.disable()
		
	if is_died:
		state = states.DIED
		damage_area_2d.disable()
		
	match state:
		states.RUN:
			damage_area_2d.enable()
			
			if length > 200:
				velocity = vector.normalized() * speed * speed_scale
			else:
				away_vector_normalized = vector.normalized()
				state = states.AWAY
			
			animated_sprite_2d.play("run")
			
		states.AWAY:
			if length < distance_to_around:
				velocity = away_vector_normalized * speed * speed_scale
			else:
				state = states.AROUND
				around_left_time = randi_range(3, around_max_time)
				around_angle = (-vector - Vector2.RIGHT).angle()
				
			animated_sprite_2d.play("run")
		
		states.STAY:
			animated_sprite_2d.play("idle")
			
			velocity = Vector2.ZERO
			
			if not is_stunned:
				state = states.RUN
		
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
			
			body.global_position = new_pos
			
			animated_sprite_2d.play("run")
			
		states.DIED:
			velocity = Vector2.ZERO
			
	body.vector = velocity
	rotate_sprite()
