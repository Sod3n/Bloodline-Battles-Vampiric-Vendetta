class_name GhostMob
extends "res://scripts/mobs/mob.gd"

@export var attack_cooldown = 1

@onready var player_body : Node2D = Global.player.body
@onready var damage_area_2d = $CharacterBody2D/DamageArea2D

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
		states.STAY:
			velocity = Vector2.ZERO
			if not is_stunned:
				state = states.MOVE
		states.DIED:
			velocity = Vector2.ZERO
	
	body.vector = velocity
	
	rotate_sprite()



func _on_damage_area_2d_on_enter(body):
	body.receive_damage(damage)
	damage_area_2d.disable()
	get_tree().create_timer(attack_cooldown * reload).timeout.connect(Callable(self, "_enable_damage_area"))


func _enable_damage_area():
	damage_area_2d.enable()
	print("damage_area_2d")
