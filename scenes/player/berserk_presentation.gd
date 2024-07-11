extends AnimatedSprite2D
@export var character : Character


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a = character.get_berserk_percent() / 100 * 1.25
	print(character, " ", character.damage_scale_by_lost_health)
