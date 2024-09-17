class_name LetterToLetterComponent
extends Node

@export var time_between_letters:float
@export var autostart:bool

var target:Label
var visible_characters = 0
var max_visible_characters = 0
var timer:SceneTreeTimer

func _ready():
	target = get_parent()
	max_visible_characters = len(target.text)
	tree_exiting.connect(stop)
	if autostart:
		next_letter()
	
func next_letter():
	visible_characters = wrapi(visible_characters + 1, 0, max_visible_characters)
	target.visible_characters = visible_characters
	timer = get_tree().create_timer(time_between_letters)
	timer.timeout.connect(next_letter)
	
func stop():
	timer.timeout.disconnect(next_letter)
