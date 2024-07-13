class_name Character
extends Node2D

signal on_died
signal on_focus_changed(value: bool)
signal on_stun_changed(value: bool)

@onready var animated_sprite_2d : AnimatedSprite2D = find_child("AnimatedSprite2D")
@export var hp = 1000.0: set = set_hp

func set_hp(value):
	hp = value

var _next_focus_value : bool = false
var _focuse_timer: Timer = Timer.new()

func set_focused(value: bool):
	if not value:
		_next_focus_value = value
		_set_focused()
		_focuse_timer.stop()
	
	if value != is_focused and _next_focus_value != value:
		_focuse_timer.one_shot = true
		_focuse_timer.start(focus_time)
		_next_focus_value = value

func _set_focused():
	is_focused = _next_focus_value
	on_focus_changed.emit(_next_focus_value)

@export var max_hp : float  = 1000.0
@export var speed : float  = 600.0
var speed_scale : float  = 1.0
@export var crit_chance : int  = 15.0
@export var crit_damage : int  = 150.0
@export var attack : float = 10.0
@export var damage_decrease : float = 0.0
@export var reload : float = 1.0
@export var invincibility_time : float = 3.0
@export var is_invincible : bool = false
@export var invincible_effect_rate : int = 8
@export var return_off_received_damage : float = 0.0
@export var damage_scale_by_lost_health : float = 0.0
@export var focus_scale : float = 0.0
@export var focus_time : float = 1.0
@export var stun_from_crit_duration : float = 0.5
@export var default_target : Node2D


@onready var presentation = %Presentation

var invincibility_current_time := 0.0
var invincibility_blink := 0.0
var is_stunned := false
var is_focused := false


var _stun_remaining_time := 0.0


var velocity : Vector2
var is_died := false
var body : Mover


var is_damage_was_crit := false

var damage:
	get:
		var dmg = attack
		var crit = randi_range(0, 100)
		is_damage_was_crit = crit < crit_chance
		if is_damage_was_crit:
			dmg *= crit_damage /100
		dmg *= 1 + get_berserk_percent() / 100 # scale damage by percent of lost health
		if is_focused:
			dmg *= 1 + (focus_scale / 100)
		return dmg

func get_berserk_percent():
	return (((max_hp - hp) / (max_hp / 100)) * damage_scale_by_lost_health)

func _ready():
	add_child(_focuse_timer)
	_focuse_timer.timeout.connect(_set_focused)
	if not default_target:
		default_target = self

func _process(delta):
	if is_invincible:
		# Halve opacity every uneven frame counts
		animated_sprite_2d.modulate.a = 0.7 if Engine.get_frames_drawn() % invincible_effect_rate > invincible_effect_rate / 2 else 1.0
	else:
		# But beware... if the last damage frame is not even,
		# you risk to leave your character half transparent!
		# Preferably do this when you set your flag back to false
		animated_sprite_2d.modulate.a = 1.0
	
	if(invincibility_current_time < 0):
		is_invincible = false
	else:
		invincibility_current_time -= delta
		
	if _stun_remaining_time < 0 and is_stunned == true:
		is_stunned = false
		on_stun_changed.emit(is_stunned)
	else:
		_stun_remaining_time -= delta

func receive_damage(damage: Damage) -> bool:
	if is_invincible or is_died:
		return false
		
	invincibility_current_time = invincibility_time
	is_invincible = true
	if damage.is_direct:
		var return_damage := return_damage(damage)
		return_damage.inflict()
	
	hp -= damage.value * (1 - damage_decrease / 100)
	
	if damage.is_crit:
		stun(stun_from_crit_duration)
	
	if hp <= 0:
		die()
	
	return true

func return_damage(damage : Damage) -> Damage:
	var return_damage = Damage.new()
	return_damage.value = damage.value * return_off_received_damage / 100
	return_damage.owner = self
	return_damage.target = damage.owner
	return_damage.is_direct = false
	return_damage.is_crit = false
	return return_damage

func rotate_sprite():
	if velocity.x < 0:
		presentation.scale = Vector2(-1, 1)
	elif velocity.x > 0:
		presentation.scale = Vector2(1, 1)

func die():
	is_died = true
	on_died.emit()
	
func stun(value):
	_stun_remaining_time = value
	is_stunned = true
	on_stun_changed.emit(is_stunned)

func can_act():
	return not is_stunned and not is_died

func get_target() -> Node2D:
	return default_target

