class_name CircleAttack
extends AttackCommand

const BULLET_LARGE = preload("res://scenes/weapons/bullet_large.tscn")

@export_range(4, 100, 2) var number_of_bullets : int
@export var rotation_speed : float = 0
@export var bullet_ref : ShooterRay

var _shooter : Shooter
var _fake_target : Node2D
var _scythe : Scythe

func init(shooter : Shooter, fake_target : Node2D, scythe: Scythe = null):
	init_timers(shooter)
	_shooter = shooter
	_fake_target = fake_target
	_scythe = scythe
	
	_shooter.bullet = BULLET_LARGE
	_shooter.target = _fake_target
	_shooter.rotation_speed = rotation_speed
	
	var deviation_step = 180 / (number_of_bullets / 2)
	
	var bullet = bullet_ref.duplicate()
	bullet.deviation = 0
	shooter.rays.append(bullet)
	bullet = bullet_ref.duplicate()
	bullet.deviation = 180
	shooter.rays.append(bullet)
	
	for i in range(1, (number_of_bullets / 2)):
		bullet = bullet_ref.duplicate()
		var bullet_2 = bullet_ref.duplicate()
		bullet.deviation = deviation_step * i
		bullet_2.deviation = -deviation_step * i
		shooter.rays.append(bullet)
		shooter.rays.append(bullet_2)
	shooter.initialize()
	shooter.deactivate()

func start():
	super()
	_shooter.activate()
	if _scythe:
		_scythe.move_to_target_node(Global.player.body)

func stop():
	_shooter.deactivate()
