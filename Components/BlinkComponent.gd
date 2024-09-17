class_name BlinkComponent
extends Node

signal blink_finished

@export var target:Node
@export var duration:float
@export var times_to_blink:int
@export var autostart:bool

var duration_of_blink:float
var tween:Tween

func _ready():
	if autostart:
		blink(times_to_blink, duration)
	
func blink(times:int = 3, dur:float = 0.7):
	if times >= 0:
		duration_of_blink = dur/(times*2)
	else:
		duration_of_blink = dur
	times_to_blink = times
	_blink_once()


func _finish_blink():
	times_to_blink -= 1
	if times_to_blink != 0:
		_blink_once()
	else:
		blink_finished.emit()


func _blink_once():
	tween = create_tween()
	tween.tween_property(target, "modulate:a", 0, duration_of_blink)
	tween.chain().tween_property(target, "modulate:a", 1, duration_of_blink)
	tween.finished.connect(_finish_blink)

func stop():
	tween.stop()
	create_tween().tween_property(target, "modulate:a", 1, 0.1)
