class_name BlobComponent
extends Node

signal blob_finished

@export var target:Node

@export var duration:float
@export var times_to_blob:int
@export var autostart:bool

var duration_of_blob:float

func _ready():
	if autostart:
		blob(duration, times_to_blob)
	
func blob(dur:float, times:int):
	if times >= 0:
		duration_of_blob = dur/(times*2)
	else:
		duration_of_blob = 0.3
	times_to_blob = times
	_blob_once()


func _finish_blob():
	times_to_blob -= 1
	if times_to_blob != 0:
		_blob_once()
	else:
		blob_finished.emit()


func _blob_once():
	var tween = create_tween()
	tween.tween_property(target, "scale", Vector2(1.1,1.1), duration_of_blob)
	tween.chain().tween_property(target, "scale", Vector2(1.0,1.0), duration_of_blob)
	tween.finished.connect(_finish_blob)
