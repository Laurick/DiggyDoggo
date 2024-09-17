extends Control

var image_touched = preload("res://TILESET/up_arrow.tres")
var image_untouched = preload("res://TILESET/up_arrow_simple.tres")

@onready var blink_component: BlinkComponent = $Label/BlinkComponent
@onready var down: TextureRect = $Down
@onready var up: TextureRect = $Up
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var focused = false
var index = 0
const letters:Array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"," ","-"]
var can_type = true

func _gui_input(event: InputEvent) -> void:
	if focused and can_type:
		if event.is_action_pressed("ui_down"):
			audio_stream_player.play()
			create_tween().tween_property(down,"position",Vector2(0,79),0.1)
			index = wrapi(index-1,0,letters.size())
			set_letter()
			down.texture = image_touched
			await get_tree().create_timer(0.1).timeout
			down.texture = image_untouched
			create_tween().tween_property(down,"position",Vector2(0,74),0.1)
			can_type = false
			get_tree().create_timer(0.1).timeout.connect(func (): can_type = true)
		if event.is_action_pressed("ui_up"):
			audio_stream_player.play()
			index = wrapi(index+1,0,letters.size())
			create_tween().tween_property(up,"position",Vector2(0,-5),0.1)
			set_letter()
			up.texture = image_touched
			await get_tree().create_timer(0.1).timeout
			create_tween().tween_property(up,"position",Vector2(0,0),0.1)
			up.texture = image_untouched
			can_type = false
			get_tree().create_timer(0.1).timeout.connect(func (): can_type = true)

func get_letter():
	return letters[index]

func set_letter():
	label.text = letters[index]
	
func _on_focus_entered() -> void:
	focused = true
	blink_component.blink(-1,0.2)

func _on_focus_exited() -> void:
	focused = false
	blink_component.stop()
