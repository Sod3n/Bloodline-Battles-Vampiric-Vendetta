extends Button

@onready var tween : Tween

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	_set_normal_state()
	grab_focus()

func _on_mouse_entered():
	_set_hover_state()

func _on_mouse_exited():
	_set_normal_state()

func _on_pressed():
	_set_pressed_state()

func _on_released():
	_set_hover_state()

func _on_focus_entered():
	_set_hover_state()

func _on_focus_exited():
	_set_normal_state()

func _set_normal_state():
	tween = create_tween()
	if tween:
		tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

func _set_hover_state():
	tween = create_tween()
	if tween:
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

func _set_pressed_state():
	tween = create_tween()
	if tween:
		tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


func _on_button_up():
	_set_hover_state()



