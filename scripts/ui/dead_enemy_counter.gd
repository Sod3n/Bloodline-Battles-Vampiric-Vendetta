extends Label


func _process(delta):
	text = str(Global.mob_manager.dead_mobs_count)
