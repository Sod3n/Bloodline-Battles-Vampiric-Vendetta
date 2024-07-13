class_name Trail
extends GPUParticles2D

@export var skins : SkinSelector
@onready var presentation = %Presentation
@export var character : BasicCharacter

var tween: Tween

func _process(delta):
	global_position = skins.global_position
	scale = presentation.scale
	if skins.animated_sprite:
		texture = skins.animated_sprite.sprite_frames \
			.get_frame_texture(skins.animated_sprite.animation, skins.animated_sprite.frame)
		if presentation.scale.x < 0:
			var img = texture.get_image()
			img.flip_x()
			texture = ImageTexture.create_from_image(img)
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", (character.extra_speed / ((character.speed * (character.speed_on_nonstop_cap / 100 - 1)) / 100)) / 100, 1)
