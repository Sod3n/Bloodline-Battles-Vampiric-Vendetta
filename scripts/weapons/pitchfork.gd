extends Node2D

@export var reload_time = 5.0
@export var attack_speed = 1500
@export var return_speed = 900
@export var _attack_distance = 1000
@export var rotation_speed = 10

@onready var pitchfork_point = $".."
@onready var damage_area_2d = $DamageArea2D
@onready var timer = $Timer

enum _states { WAIT, ATTACK, RETURN }

var _state = _states.WAIT

var player : Node = Global.player

var _attack_point = Vector2.ZERO

var _return_distance = 0.0

var _target : Node2D

func _ready():
	_return_distance = pitchfork_point.position.distance_to(position)
	timer.timeout.connect(_attack_state)
	_wait_state()

func _process(delta):
	if not Global.player.can_act():
		return
	
	match _state:
		_states.WAIT:
			damage_area_2d.disable()
			
			if player.target != null:
				if _target == player.default_target:
					_target = player.random_target
				if not player.targets.has(_target):
					_target = player.random_target
			
			if _target != null:
				var angle = player.body.global_position.direction_to(_target.global_position).angle()
					
				pitchfork_point.rotation = lerp_angle(pitchfork_point.rotation, angle, delta * rotation_speed)
			elif player.target != null:
				_target = player.random_target
			else:
				_target = player.default_target
			
		_states.ATTACK:
			damage_area_2d.enable()
			
			position += Vector2.RIGHT * delta * attack_speed
			print(_attack_distance)
			if position.distance_to(pitchfork_point.position) > _attack_distance:
				_return_state()
		
		_states.RETURN:
			damage_area_2d.disable()
			
			position += position.direction_to(pitchfork_point.position) * delta * return_speed
			
			if position.distance_to(pitchfork_point.position) < _return_distance:
				_wait_state()

func _attack_state():
	if _target == null:
		_wait_state()
		return
	
	_state = _states.ATTACK
	_attack_point = _target.global_position
	timer.stop()

func _return_state():
	_state = _states.RETURN
	
func _wait_state():
	_state = _states.WAIT
	timer.start(reload_time * player.reload)
	if player:
		_target = player.random_target
	
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func _on_damage_area_2d_on_enter(body):
	var damage = Global.player.damage
	body.receive_damage(damage)
	GlobalDamageNumbersManager.show_damage(damage, Global.player.is_damage_was_crit, global_position)
