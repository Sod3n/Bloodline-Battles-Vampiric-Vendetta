class_name DamageNumber
extends Label

var damage_size_mod = 1000

# Метод для настройки текста урона и размера шрифта
func set_damage(damage: float, is_crit: bool) -> void:
	text = str(damage)
	
	# Устанавливаем размер шрифта в зависимости от значения урона
	var font_size = int(max(32, min(64, damage / damage_size_mod)))  # Пример: минимальный размер 12, максимальный 48
	
	var font := FontVariation.new()
	font.set_base_font(load("res://assets/joystix monospace.otf"))
	self.add_theme_font_override("font", font)
	self.add_theme_font_size_override("font_size", font_size)
	var color := Color.GHOST_WHITE
	if is_crit:
		color = Color.CRIMSON
	
	self.add_theme_color_override("font_color", color)
