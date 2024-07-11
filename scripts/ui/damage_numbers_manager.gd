class_name DamageNumbersManager
extends Node

# Метод для отображения урона в заданной точке
func show_damage(damage: Damage) -> void:
	if damage.value == 0:
		return
	# Создаем новый экземпляр DamageNumber
	var damage_number := DamageNumber.new()
	damage_number.set_damage(damage.value, damage.is_crit)
	
	# Устанавливаем позицию damage_number
	damage_number.global_position = damage.target.body.global_position
	
	# Добавляем его в сцену
	add_child(damage_number)
	
	# Создаем Tween для анимации
	var tween := get_tree().create_tween()
	
	# Настраиваем анимацию плавного исчезновения
	tween.tween_property(damage_number, "modulate:a", 0.0, 1.0)  # Анимация альфа-канала на 1 секунду
	
	# По окончании анимации удаляем damage_number и сам tween
	tween.finished.connect(Callable(self, "_on_tween_finished").bind(damage_number, tween))
	tween.play()

# Слот для удаления damage_number и tween
func _on_tween_finished(damage_number: DamageNumber, tween: Tween) -> void:
	damage_number.queue_free()
	tween.kill()
