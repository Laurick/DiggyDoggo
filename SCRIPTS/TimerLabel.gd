class_name TimedLabel
extends Label

signal timeout

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var time: int

var timer:Timer
var last_beep:int

func start() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(timeout_timer)
	timer.start(time)
	last_beep = 5

func is_stopped():
	return true if !timer else timer.is_stopped()
	
func stop() -> void:
	timer.timeout.disconnect(timeout_timer)
	timer.stop()
	remove_child(timer)
	timer = null

func _process(_delta: float) -> void:
	if timer:
		var t = int(timer.time_left)
		text = str(t)
		if t < last_beep:
			last_beep = t
			audio_stream_player.play()


func timeout_timer():
	timeout.emit()
