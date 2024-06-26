extends Node2D

@export var attack_rotation_speed = 1200
@export var prepare_rotation_speed = 200
@export var rotation_speed = 5

# Constants for states
enum WeaponState {
	WAIT_ATTACK,
	PREPARE_ATTACK,
	ATTACK
}

# Current state of the weapon
var state = WeaponState.WAIT_ATTACK

# Shovel point for rotation
var shovel_point

# Damage area 2D node
var damage_area

var player = Player

# Additional angle for prepare attack
var additional_angle = 120

# Additional angle for attack
var additional_attack_angle = 75 + 120

# Time to wait in wait attack state (in seconds)
var wait_attack_time = 5.0

var rotate_distance = 0.0

var attack_direct_to_left = false

var _target : Node2D

# Called when the node enters the scene tree for the first time
func _ready():
	shovel_point = $".."
	damage_area = $DamageArea2D
	_wait_attack()

# Process function called every frame
func _process(delta):
	match state:
		
		WeaponState.WAIT_ATTACK:
			if player.target != null:
				if _target == player.default_target:
					_target = player.random_target
				if not player.targets.has(_target):
					_target = player.random_target
			
			if _target != null:
				shovel_point.rotation = lerp_angle(shovel_point.rotation, shovel_point.global_position.angle_to_point(_target.global_position), rotation_speed * delta)
				damage_area.disable()
				var point_rot = get_rotation_between_neg_pi_and_pi(shovel_point)
				attack_direct_to_left = abs(point_rot) > PI / 2
			elif player.target != null:
				_target = player.random_target
			else:
				_target = player.default_target

		WeaponState.PREPARE_ATTACK:
			if rotate_object(shovel_point, attack_direct_to_left, prepare_rotation_speed, additional_angle):
				state = WeaponState.ATTACK
				rotate_distance = 0

		WeaponState.ATTACK:
			damage_area.enable()
			if rotate_object(shovel_point, !attack_direct_to_left, attack_rotation_speed, additional_attack_angle):
				_wait_attack()
				rotate_distance = 0

# Function to rotate an object clockwise or counterclockwise
func rotate_object(object_to_rotate: Node2D, clockwise: bool, speed: float, angle: float) -> bool:
	# Calculate rotation direction
	var rotation_direction = 1 if clockwise else -1
	
	# Calculate rotation increment based on speed
	var rotation_increment = speed * rotation_direction * get_process_delta_time()
	# Rotate the object until desired angle is reached
	if rotate_distance < abs(angle):
		object_to_rotate.rotation_degrees += rotation_increment
		rotate_distance += abs(rotation_increment)
		return false
	else:
		return true

# Wait in WAIT_ATTACK state and then switch to PREPARE_ATTACK state
func _wait_attack():
	if player:
		_target = player.random_target
	state = WeaponState.WAIT_ATTACK
	await get_tree().create_timer(wait_attack_time * player.reload).timeout
	rotate_distance = 0
	state = WeaponState.PREPARE_ATTACK


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func get_rotation_between_neg_pi_and_pi(object_to_check: Node2D) -> float:
	# Get the raw rotation of the object
	var raw_rotation = object_to_check.rotation

	# Ensure the rotation is between -2*pi and 2*pi
	raw_rotation = fmod(raw_rotation, 2 * PI)

	# Normalize the rotation to be between -pi and pi
	var rotation_neg_pi_to_pi = raw_rotation
	if rotation_neg_pi_to_pi > PI:
		rotation_neg_pi_to_pi -= 2 * PI

	return rotation_neg_pi_to_pi


func _on_damage_area_2d_on_enter(body):
	body.receive_damage(Player.damage)
