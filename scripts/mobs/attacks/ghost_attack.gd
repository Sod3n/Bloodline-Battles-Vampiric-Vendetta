class_name GhostAttack
extends AttackCommand

const GHOST_MOB = preload("res://scenes/mobs/ghost_mob.tscn")

@export var ghost_speed: float = 1000
@export var stun_time: float = 3

var body : Node2D

func init(body: Node2D):
	self.body = body
	init_timers(body)

func start():
	super()
	var mob : GhostMob = GHOST_MOB.instantiate()
	mob.direction = Global.player.body.global_position - body.global_position
	mob.speed = ghost_speed
	mob.stun_time = stun_time
	body.get_tree().current_scene.add_child(mob)
	mob.global_position = body.global_position

func stop():
	pass
