class_name BasicCharacter
extends "res://scripts/character_components/character.gd"

const GAME_OVER_SCREEN = preload("res://scenes/ui/game_over_screen.tscn")

@onready var health_bar : ProgressBar = %HealthBar
@onready var exp_bar : ProgressBar = %ExpBar
@onready var collect_shape_2d : CollisionShape2D = $CharacterBody2D/CollectArea2D/CollisionShape2D
@onready var weapon_slots : WeaponSlots = %WeaponSlots

@onready var skins : SkinSelector = $CharacterBody2D/Skins
@export var speed_scale_on_damage : float = 0.5
@export var speed_scale_on_damage_time : float = 0.5
@export var in_main_menu : bool = false
@onready var counter = %Counter
@export var speed_on_nonstop := 0
@export var speed_on_nonstop_frequency := 0.5
@export var speed_on_nonstop_cap := 200

@onready var savestate = $Savestate

var _target: Node2D
var extra_speed := 0
var _speed_on_nonstop_timer := Timer.new()


func _init():
	Global.player = self
	
func _ready():
	super()
	update_healthbar(100)
	body = $CharacterBody2D
	if in_main_menu:
		_stun_remaining_time = 9999999
		is_stunned = true
		weapon_slots.hide()
		health_bar.hide()
		exp_bar.hide()
		counter.hide()
	savestate.load_game_state()
	savestate.get_game_variables(skins)
	
	add_child(_speed_on_nonstop_timer)
	_speed_on_nonstop_timer.timeout.connect(add_extra_speed)
	_speed_on_nonstop_timer.wait_time = speed_on_nonstop_frequency

func add_extra_speed():
	extra_speed += speed_on_nonstop
	if extra_speed >= speed_on_nonstop_cap / 100 * speed:
		extra_speed = speed_on_nonstop_cap / 100 * speed

func set_hp(value):
	super(value)
	update_healthbar(hp / (max_hp / 100))

var exp = 0.0 :
	set(value):
		if is_died:
			return
		
		exp += value
		
		var need_exp = 10 + pow(5, level / 2)
		
		while exp >= need_exp:
			exp -= need_exp
			level += 1
			need_exp = 10 + pow(5, level / 2)
			Global.upgrade_menu.activate()
			#hp = max_hp
			await Signal(Global.upgrade_menu, 'deactivated')
			
		
		exp_bar.value = exp / (need_exp / 100)
		
var level = 1
	

var collect_radius:
	set(value):
		collect_shape_2d.shape.radius = value
	get:
		return collect_shape_2d.shape.radius

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * (speed + extra_speed) * speed_scale

func _process(delta):
	super(delta)
	
	body.vector = Vector2.ZERO
	
	get_input()
	
	if is_died:
		animated_sprite_2d.play("die")
	elif is_stunned:
		_speed_on_nonstop_timer.stop()
		extra_speed = 0
		animated_sprite_2d.play("idle")
	
	
	if not can_act():
		return
	
	var in_move = velocity.length() > 0
	
	set_focused(focus_scale > 0 and not in_move)
	
	if in_move:
		if _speed_on_nonstop_timer.time_left <= 0:
			_speed_on_nonstop_timer.start()
		animated_sprite_2d.play("run")
	else:
		_speed_on_nonstop_timer.stop()
		extra_speed = 0
		animated_sprite_2d.play("idle")
	
	body.vector = velocity
	rotate_sprite()
		

func update_healthbar(health):
	if health_bar:
		health_bar.value = health
	


var targets : Array

var first_target:
	get:
		_clear_dead_targets()
		if targets.size() > 0:
			return targets[0]
			
		return null

var random_target:
	get:
		_clear_dead_targets()
		if targets.size() > 0:
			return targets.pick_random()
			
		return null

func _clear_dead_targets():
	for T in targets:
		if T.get_owner().is_died:
			targets.erase(T)

func _on_target_area_2d_body_entered(body):
	if not body.get_owner().is_died:
		targets.append(body)
		update_target()

func _on_target_area_2d_body_exited(body):
	targets.erase(body)
	update_target()

func get_target() -> Node2D:
	update_target()
	return _target

func update_target():
	if _target != null and _target != default_target:
		return
	
	if first_target != null:
		_target = random_target
	else:
		_target = default_target

func die():
	super()
	var game_over_screen = GAME_OVER_SCREEN.instantiate()
	add_child(game_over_screen)
	Global.stopwatch.stop()
	fade_out()
	game_over_screen.show_game_over()

func fade_out():
	var fade_out = create_tween()
	fade_out.tween_property(self, "modulate:a", 0.0, 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


func receive_damage(damage: Damage) -> bool:
	var res = super(damage)
	if res:
		speed_scale = speed_scale_on_damage_time
		get_tree().create_timer(speed_scale_on_damage_time).timeout.connect(reset_speed_scale)
		speed_scale = 1
	
	return res

func reset_speed_scale():
	speed_scale = 1
