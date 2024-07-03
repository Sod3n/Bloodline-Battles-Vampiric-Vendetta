class_name MobWaveBossSpawnEvent
extends MobWaveEvent

const DEATH_MOB = preload("res://scenes/mobs/death_mob.tscn")
const WIN = preload("res://scenes/ui/win.tscn")

func start():
	var mob = DEATH_MOB.instantiate()
	get_tree().current_scene.add_child(mob)
	mob.global_position = Global.boss_spawn_point
	mob.on_died.connect(win)

func win():
	Global.mob_manager.kill_all()
	await get_tree().create_timer(3).timeout
	var win = WIN.instantiate()
	get_tree().current_scene.add_child(win)
