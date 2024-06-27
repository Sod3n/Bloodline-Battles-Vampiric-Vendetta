class_name Mover
extends CharacterBody2D

var vector : Vector2

func _physics_process(delta):
	velocity = vector
	move_and_slide()

