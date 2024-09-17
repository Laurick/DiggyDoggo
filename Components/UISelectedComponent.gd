class_name UISelectedComponent
extends AudioStreamPlayer

func _ready():
	stream = preload("res://AUDIO/menu.wav")
	bus = &"sfx"
	get_parent().focus_entered.connect(playSound)
	
func playSound():
	randomize()
	pitch_scale = randf_range(0.8, 1.2)
	play()
