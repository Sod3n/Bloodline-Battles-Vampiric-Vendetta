class_name Pitchfork
extends Weapon

@export var reload_time = 5.0
@export var attack_speed = 1500
@export var return_speed = 900
@export var _attack_distance = 1000
@export var rotation_speed = 10

@onready var pitchfork_point = %PitchforkPoint
@onready var timer = %Timer

enum _states { WAIT, ATTACK, RETURN }

var _state = _states.WAIT

var _attack_point = Vector2.ZERO

var _return_distance = 0.0

func _ready():
	_return_distance = pitchfork_point.position.distance_to(position)
	timer.timeout.connect(_attack_state)
	_wait_state()

func _process(delta):
	if not weapon_owner.can_act():
		return
	
	target = weapon_owner.get_target()
	
	match _state:
		_states.WAIT:
			damage_area.disable()
			
			var angle = weapon_owner.body.global_position.direction_to(target.global_position).angle()
			self.rotation = lerp_angle(self.rotation, angle, delta * rotation_speed)
		_states.ATTACK:
			damage_area.enable()
			
			pitchfork_point.position += Vector2.RIGHT * delta * attack_speed

			if pitchfork_point.position.distance_to(self.position) > _attack_distance:
				_return_state()
		
		_states.RETURN:
			damage_area.disable()
			
			pitchfork_point.position += pitchfork_point.position.direction_to(self.position) * delta * return_speed
			
			if position.distance_to(pitchfork_point.position) < _return_distance:
				_wait_state()

func _attack_state():
	if target == null:
		_wait_state()
		return
	var angle = weapon_owner.body.global_position.direction_to(target.global_position).angle()
	self.rotation = lerp_angle(self.rotation, angle, 1)
	_state = _states.ATTACK
	_attack_point = target.global_position
	timer.stop()

func _return_state():
	_state = _states.RETURN
	
func _wait_state():
	_state = _states.WAIT
	timer.start(reload_time * weapon_owner.reload)
	
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func _on_damage_area_2d_on_enter(body):
	var dmg = Damage.new()
	dmg.value = weapon_owner.damage
	dmg.owner = weapon_owner
	dmg.target = body
	dmg.is_direct = true
	dmg.is_crit = weapon_owner.is_damage_was_crit
	dmg.inflict()
