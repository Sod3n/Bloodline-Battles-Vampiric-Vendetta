class_name Mob
extends "res://scripts/character_components/character.gd"

@export_enum("Copper", "Silver", "Gold") var coin_drops: int

const GOLD_COIN = preload("res://scenes/collectables/gold_coin.tscn")
const SILVER_COIN = preload("res://scenes/collectables/silver_coin.tscn")
const COPPER_COIN = preload("res://scenes/collectables/copper_coin.tscn")

@onready var player_body : Node2D = Global.player.body

var alpha = 1
var alpha_speed = 0.2

var dropped_collectable

func _ready():
	Global.mob_manager.mobs.append(self)


func die():
	super()
	animated_sprite_2d.play("die")
	
	var coin : Node2D
	
	match coin_drops:
		0:
			coin = COPPER_COIN.instantiate()
		1:
			coin = SILVER_COIN.instantiate()
		2:
			coin = GOLD_COIN.instantiate()
	
	coin.global_position = body.global_position
	get_tree().current_scene.call_deferred("add_child", coin)
	
	if dropped_collectable != null:
		var collectable = dropped_collectable.instantiate()
		collectable.global_position = body.global_position
		get_tree().current_scene.call_deferred("add_child", collectable)
	

func _process(delta):
	super(delta)
	
	if is_died:
		alpha -= delta * alpha_speed
		animated_sprite_2d.modulate.a = alpha
	
	if alpha <= 0:
		queue_free()


func keep_distance_with_player(keep_distance : float, distance_spread : float) -> bool:
	var player_pos = player_body.global_position
	var vector = player_pos - body.global_position
	var min_distance = keep_distance - distance_spread
	var max_distance = keep_distance + distance_spread  
	var length = vector.length()
	
	if abs(length - keep_distance) > 10:
		velocity = (vector.normalized() * sign(length - keep_distance) * speed * speed_scale)
		return true
	else:
		return false
