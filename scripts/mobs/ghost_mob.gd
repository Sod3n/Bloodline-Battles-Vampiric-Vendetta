class_name GhostMob
extends "res://scripts/mobs/mob.gd"

@export var stun_time = 1.5

var direction : Vector2

func _ready():
	super()
	body = $CharacterBody2D


enum states {MOVE, STAY, DIED}
var state = states.MOVE

func _process(delta):
	super(delta)
	
	var player_pos = player_body.global_position
	
	if is_stunned:
		damage_area_2d.disable()
		state = states.STAY
	
	if is_died:
		damage_area_2d.disable()
		state = states.DIED
		
	if not Global.point_randomizer.is_point_inside_rect(body.global_position, player_pos, body.get_viewport_rect().size * 4):
		queue_free()
	
	match state:
		states.MOVE:
			animated_sprite_2d.play("run")
			velocity = (direction.normalized() * speed * speed_scale)
			_enable_damage_area()
		states.STAY:
			velocity = Vector2.ZERO
			if can_act():
				state = states.MOVE
		states.DIED:
			velocity = Vector2.ZERO
	
	body.vector = velocity
	
	rotate_sprite()



func _on_damage_area_2d_on_enter(body: Character):
	super(body)
	body.stun(stun_time)
	die()


func _enable_damage_area():
	damage_area_2d.enable()
