class_name AttackCommand
extends Resource

@export var rest_time : float = 3
@export var duration : float = 3

var is_ended : bool = true
var is_rested : bool = true

var _duration_timer : Timer = Timer.new()
var _rest_timer : Timer = Timer.new()

var _timer_runner : Node2D

func init_timers(timer_runner: Node2D):
	_timer_runner = timer_runner
	_duration_timer = Timer.new()
	_rest_timer = Timer.new()
	_timer_runner.add_child(_duration_timer)
	_duration_timer.timeout.connect(on_end)
	_duration_timer.one_shot = true
	_timer_runner.add_child(_rest_timer)
	_rest_timer.timeout.connect(on_rest)
	_rest_timer.one_shot = true

func is_ended_and_rested() -> bool:
	return is_ended and is_rested

func start():
	is_ended = false
	is_rested = false
	_duration_timer.start(duration)
	
func on_end():
	is_ended = true
	_rest_timer.start(rest_time)
	stop()
	
func on_rest():
	is_rested = true

func stop():
	pass
