class_name Scythe
extends Weapon


@export var reload_time = 5.0
@export var move_speed = 1500
@export var return_speed = 900
@export var rotation_speed = 10
@export var delay_before_return = 1.0

@onready var handle_point = $".."
@onready var return_timer = Timer.new()

enum _states { WAIT, ROTATE_TO_TARGET, MOVE, RETURN }

var _state = _states.WAIT

var _target_node : Node2D
var _target_point = Vector2.ZERO
var _initial_position = Vector2.ZERO
var _initial_rotation = 0.0

func _ready():
	_initial_position = position
	_initial_rotation = rotation
	return_timer.one_shot = true
	add_child(return_timer)
	return_timer.timeout.connect(_return_state)
	_wait_state()

func _process(delta):
	if not weapon_owner.can_act():
		return
	
	target = weapon_owner.get_target()
	
	match _state:
		_states.WAIT:
			damage_area.disable()
		
		_states.ROTATE_TO_TARGET:
			if _target_node != null:
				_target_point = _target_node.global_position
				var target_angle = (global_position.direction_to(_target_point)).angle()
				rotation = lerp_angle(rotation, target_angle, delta * rotation_speed)
				if abs(short_angle_dist(rotation, target_angle)) < deg_to_rad(5): # Adjust threshold as needed
					_move_to_target()
		
		_states.MOVE:
			if global_position.distance_to(_target_point) < 30: # 10 can be adjusted as a threshold
				if return_timer.time_left == 0:
					return_timer.start(delay_before_return)
				global_position = _target_point
				return
			
			damage_area.enable()
			var direction = global_position.direction_to(_target_point)
			global_position += direction * delta * move_speed
		
		_states.RETURN:
			damage_area.disable()
			var return_direction = position.direction_to(_initial_position)
			position += return_direction * delta * return_speed
			rotation = lerp_angle(rotation, _initial_rotation, delta * rotation_speed)
			
			if position.distance_to(_initial_position) < 30 and abs(short_angle_dist(rotation, _initial_rotation)) < deg_to_rad(5): # Adjust thresholds as needed
				_wait_state()

func move_to_target_node(target_node: Node2D):
	_target_node = target_node
	_state = _states.ROTATE_TO_TARGET

func _move_to_target():
	_target_point = _target_node.global_position
	_state = _states.MOVE

func _return_state():
	_state = _states.RETURN

func _wait_state():
	_state = _states.WAIT
