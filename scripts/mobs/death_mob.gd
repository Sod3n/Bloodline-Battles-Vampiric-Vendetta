extends "res://scripts/mobs/mob.gd"

const BULLET_LARGE = preload("res://scenes/weapons/bullet_large.tscn")

@export var circle_attack : CircleAttack
@export var ray_circle_attack : CircleAttack
@export var ghost_attack : GhostAttack

@export var circle_attack_count : int = 5
@export var ghost_attack_freshold : int = 2

@export_group("Contact attack")
@export var cooldown_time : float = 2

@export_group("Movement")
@export var keep_distance : float = 500
@export var distance_spread : float  = 100


@onready var shooter : Shooter = %Shooter
@onready var fake_target = %FakeTarget
@onready var shooter2 : Shooter = %Shooter2
@onready var fake_target2 = %FakeTarget2

@onready var scythe = %Scythe

enum states {MOVE, STAY, ATTACK, DIED}
var state = states.MOVE
var _actual_velocity : Vector2
var _last_point : Vector2

var current_attack : AttackCommand

func _ready():
	body = $CharacterBody2D
	animated_sprite_2d = %AnimatedSprite2D
	scythe.weapon_owner = self
	circle_attack.init(shooter, fake_target, scythe)
	ray_circle_attack.init(shooter2, fake_target2)
	ghost_attack.init(body)
	default_target = Global.player

var _circle_attack_counter : int = 0

func update_attack():
	if current_attack:
		if not current_attack.is_ended_and_rested():
			return
	
	if current_attack == ray_circle_attack and hp <= max_hp / ghost_attack_freshold:
		current_attack = ghost_attack
		current_attack.start()
		return
	
	if _circle_attack_counter >= circle_attack_count:
		_circle_attack_counter = 0
		current_attack = ray_circle_attack
		current_attack.start()
		return
	
	current_attack = circle_attack
	current_attack.start()
	_circle_attack_counter += 1


func _process(delta):
	super(delta)
	var player_pos = player_body.global_position
	var vector = player_pos - body.global_position
	var min_distance = keep_distance - distance_spread
	var max_distance = keep_distance + distance_spread  
	var length = vector.length()
	
	if not can_act():
		current_attack.stop()
	
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
			
			if not current_attack or current_attack.is_ended_and_rested():
				state = states.ATTACK
		
		states.ATTACK:
			update_attack()
			if current_attack.is_ended and not current_attack.is_rested:
				state = states.MOVE
		states.DIED:
			velocity = Vector2.ZERO
	
	body.vector = velocity
	
	rotate_sprite()

func _physics_process(delta):
	_actual_velocity = body.global_position - _last_point
	_last_point = body.global_position
