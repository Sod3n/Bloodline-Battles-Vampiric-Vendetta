extends Label

@onready var confetti = $"../Confetti"
@onready var confetti_2 = $"../Confetti2"

var done : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	scale_in()

func scale_in():
	var scale_in = create_tween()
	self.scale = Vector2.ZERO
	scale_in.tween_property(self, "scale", Vector2(1, 1), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).from(Vector2.ZERO)
	scale_in.tween_callback(Callable(self, "_on_scale_in_completed"))

func _on_scale_in_completed():
	confetti.emit()
	confetti_2.emit()
	await get_tree().create_timer(1).timeout
	done = true
