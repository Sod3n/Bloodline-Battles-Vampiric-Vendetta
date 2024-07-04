class_name UButton
extends Button
@onready var rich_text_label = $RichTextLabel
@onready var texture_rect = $TextureRect

func set_utext(value: String):
	rich_text_label.text = value
	
func set_uicon(value: Texture2D):
	texture_rect.texture = value
