extends "res://scripts/character.gd"


@export_enum("Copper", "Silver", "Gold") var coin_drops: int

const GOLD_COIN = preload("res://scenes/gold_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
const COPPER_COIN = preload("res://scenes/copper_coin.tscn")

var alpha = 1
var alpha_speed = 0.2

var injecter : Node2D

var is_mob_flag = true

var dropped_collectable

func _ready():
	MobManager.mobs.append(self)


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
	get_owner().add_child(coin)
	
	if dropped_collectable != null:
		var collectable = dropped_collectable.instantiate()
		collectable.global_position = body.global_position
		get_owner().add_child(collectable)
	

func _process(delta):
	super(delta)
	
	if is_died:
		alpha -= delta * alpha_speed
		animated_sprite_2d.modulate.a = alpha
	
	if alpha <= 0:
		queue_free()

func can_act():
	return not is_stunned and not is_died
