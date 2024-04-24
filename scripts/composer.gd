extends Node

@onready var player = $player


# Called when the node enters the scene tree for the first time.
func _ready():
	for N in get_all_children(self):
		if "player" in N:
			N.player = player.get_node("CharacterBody2D")


func get_all_children(node) -> Array:
	var nodes : Array = []

	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes
