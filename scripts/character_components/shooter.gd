class_name Shooter
extends Node2D

const BULLET = preload("res://scenes/weapons/bullet.tscn")

@export var rays : Array[ShooterRay]
@export var active : bool = false
@export var auto_init : bool = true
@export var rotation_speed : float = 0
@onready var range_mob = $"../.."

var bullet = BULLET
var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Global.player.body
	if auto_init:
		initialize()

func initialize():
	for ray in rays:
		ray.timer = Timer.new()
		add_child(ray.timer)
		ray.timer.timeout.connect(_on_timeout.bind(ray))
		ray.timer.wait_time = ray.frequency
		ray.timer.one_shot = false
	
	if active:
		activate()

func _on_timeout(ray : ShooterRay):
	if not range_mob.can_act():
		return
	
	var instance = bullet.instantiate()
	instance.vector = (target.global_position - self.global_position).normalized().rotated(deg_to_rad(ray.deviation))
	instance.vector *= ray.bullet_speed
	instance.global_position = self.global_position
	instance.damage = range_mob.damage
	instance.lifetime = ray.bullet_lifetime
	get_tree().current_scene.add_child.call_deferred(instance)
	pass

func activate():
	for ray in rays:
		ray.timer.start()
		ray.timer.wait_time = ray.frequency
		ray.timer.one_shot = false
		_on_timeout(ray)
	
func deactivate():
	for ray in rays:
		ray.timer.stop()

func _physics_process(delta):
	rotate(deg_to_rad(rotation_speed) * delta)
