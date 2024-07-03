extends Node2D

@onready var green = $Green
@onready var red = $Red
@onready var yellow = $Yellow


func emit():
	green.emitting = true
	red.emitting = true
	yellow.emitting = true
