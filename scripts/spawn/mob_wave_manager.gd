class_name MobWaveManager
extends Node


var waves : Array

var next_wave : MobWave

func _init():
	Global.mob_wave_manager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	waves = get_children()
	next_wave = waves.pop_front()
	start_next_wave()
	
func start_next_wave():
	if next_wave == null:
		return
	next_wave.start()
	next_wave.end.connect(Callable(self, "start_next_wave"))
	next_wave = waves.pop_front()



