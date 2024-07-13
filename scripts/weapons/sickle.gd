class_name WeaponSickle
extends Weapon

@export var attack_rotation_speed_min = 100
@export var attack_rotation_speed_max = 200
@export var self_rotation_speed = 400
@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var sickle_point = %SicklePoint

var attack_rotation_speed : float
var tween = Tween.new()
var tween_speed = Tween.new()

# Constants for states
enum WeaponState{
	WAIT_ATTACK,
	ATTACK
}

# Current state of the weapon
var state = WeaponState.WAIT_ATTACK

# Additional angle for attack
var additional_attack_angle = 180

# Time to wait in wait attack state (in seconds)
@export var wait_attack_time = 5.0

var rotate_distance = 0.0

var clockwise: bool = true

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
			damage_area.disable()
		WeaponState.ATTACK:
			damage_area.enable()
			rotate_object(sickle_point, clockwise, self_rotation_speed, 0)
			rotate_distance = rotate_object(self, clockwise, attack_rotation_speed, rotate_distance)
			
			if rotate_distance <= abs(additional_attack_angle / 2):
				speed_up()
			else:
				speed_down()
			
			if rotate_distance >= abs(additional_attack_angle):
				_wait_attack()
				clockwise = not clockwise
				rotate_distance = 0

# Function to rotate an object clockwise or counterclockwise
func rotate_object(object_to_rotate: Node2D, clockwise: bool, speed: float, rotated_distance : float) -> float:
	# Calculate rotation direction
	var rotation_direction = 1 if clockwise else -1

	# Calculate rotation increment based on speed
	var rotation_increment = speed * rotation_direction * get_process_delta_time()
	# Rotate the object until desired angle is reached
	object_to_rotate.rotation_degrees += rotation_increment
	rotated_distance += abs(rotation_increment)
	return rotated_distance

# Wait in WAIT_ATTACK state and then switch to ATTACK state
func _wait_attack():
	fade_out()
	state = WeaponState.WAIT_ATTACK
	await get_tree().create_timer(wait_attack_time * weapon_owner.reload).timeout
	fade_in()
	rotate_distance = 0
	attack_rotation_speed = attack_rotation_speed_min
	state = WeaponState.ATTACK

func fade_in() -> Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	modulate.a = 0
	tween.tween_property(self, "modulate:a", 1, 0.1)
	return tween

func fade_out():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.3)

func speed_up():
	if tween_speed:
		tween_speed.kill()
	tween_speed = get_tree().create_tween()
	tween_speed.tween_property(self, "attack_rotation_speed", attack_rotation_speed_max, 0.3)

func speed_down():
	if tween_speed:
		tween_speed.kill()
	tween_speed = get_tree().create_tween()
	tween_speed.tween_property(self, "attack_rotation_speed", attack_rotation_speed_min, 0.3)

func def_anim():
	animated_sprite_2d.animation_finished.disconnect(def_anim)
