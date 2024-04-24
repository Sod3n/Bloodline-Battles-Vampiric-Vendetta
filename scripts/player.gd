extends "res://scripts/character.gd"
@onready var node_2d = $"."
@onready var move_player = $CharacterBody2D
@onready var health_bar = $CharacterBody2D/Control/HealthBar

@export var move = true

var velocity = 0

func _ready():
	update_healthbar(100)

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed * speed_scale

func _process(delta):
	move_player.vector = Vector2.ZERO
	
	get_input()
	if(move):
		move_player.vector = (velocity)
		
func receive_damage(damage):
	super(damage)
	update_healthbar(hp / (max_hp / 100))

func update_healthbar(health):
	health_bar.value = health
