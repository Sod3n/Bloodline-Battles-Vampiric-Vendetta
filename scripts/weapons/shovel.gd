class_name WeaponShovel
extends Weapon

@export var attack_rotation_speed = 1200
@export var prepare_rotation_speed = 200
@export var rotation_speed = 5
@onready var animated_sprite_2d = %AnimatedSprite2D

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

# Additional angle for prepare attack
var additional_angle = 120

# Additional angle for attack
var additional_attack_angle = 75 + 120

# Time to wait in wait attack state (in seconds)
@export var wait_attack_time = 5.0

var rotate_distance = 0.0

var attack_direct_to_left = false

# Called when the node enters the scene tree for the first time
func _ready():
	_wait_attack()

# Process function called every frame
func _process(delta):
	if not weapon_owner.can_act():
		return
	
	target = weapon_owner.get_target()

	match state:
		
		WeaponState.WAIT_ATTACK:
			
			self.rotation = lerp_angle(self.rotation, \
				self.global_position.angle_to_point(target.global_position), \
				rotation_speed * delta)
			
			damage_area.disable()
			var point_rot = get_rotation_between_neg_pi_and_pi(self)
			attack_direct_to_left = abs(point_rot) > PI / 2

		WeaponState.PREPARE_ATTACK:
			if rotate_object(self, attack_direct_to_left, prepare_rotation_speed, additional_angle):
				state = WeaponState.ATTACK
				animated_sprite_2d.play("attack")
				rotate_distance = 0

		WeaponState.ATTACK:
			damage_area.enable()
			
			if rotate_object(self, !attack_direct_to_left, attack_rotation_speed, additional_attack_angle):
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
	animated_sprite_2d.play("default")
	
	state = WeaponState.WAIT_ATTACK
	await get_tree().create_timer(wait_attack_time * weapon_owner.reload).timeout
	rotate_distance = 0
	state = WeaponState.PREPARE_ATTACK

func def_anim():
	animated_sprite_2d.animation_finished.disconnect(def_anim)
	animated_sprite_2d.play("default")
