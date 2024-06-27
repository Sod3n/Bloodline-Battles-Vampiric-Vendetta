class_name MobWaveWallEvent
extends MobWaveEvent

const GHOST_WALL_HORIZONTAL = preload("res://scenes/ghost_wall_horizontal.tscn")
const GHOST_WALL_VERTICAL = preload("res://scenes/ghost_wall_vertical.tscn")

@export var random_side : bool = false
@export var direction_priorities : Array[PointRandomizer.Priorities] \
= [PointRandomizer.Priorities.TOP, PointRandomizer.Priorities.RIGHT, \
PointRandomizer.Priorities.LEFT, PointRandomizer.Priorities.BOTTOM]


func start():
	spawn_wall()

func stop():
	pass
	
func spawn_wall():
	if random_side:
		direction_priorities.shuffle()
	
	var spawn_data = Global.point_randomizer.generate_point_for_spawn(direction_priorities)
	var spawn_position = spawn_data[0]
	var spawn_side = spawn_data[1]
	var mob
	
	if (spawn_side == PointRandomizer.Priorities.LEFT or spawn_side == PointRandomizer.Priorities.RIGHT):
		mob = GHOST_WALL_VERTICAL.instantiate()
	else:
		mob = GHOST_WALL_HORIZONTAL.instantiate()
	
	get_tree().current_scene.add_child(mob)
	mob.owner = get_tree().current_scene
	mob.global_position = spawn_position
	mob.direction = (Global.player.body.global_position - spawn_position).normalized()
		
