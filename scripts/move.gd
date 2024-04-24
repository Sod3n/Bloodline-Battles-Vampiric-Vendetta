extends CharacterBody2D

var vector : Vector2

func _physics_process(delta):
	var collision_info = move_and_collide(vector * get_process_delta_time())

