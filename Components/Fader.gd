extends CanvasLayer

signal fader_complete

@onready var fade_canvas_top: ColorRect = $"FadeCanvas-top"
@onready var fade_canvas_mid: ColorRect = $"FadeCanvas-mid"
@onready var fade_canvas_bottom: ColorRect = $"FadeCanvas-bottom"


func fadeIn(time:float = 0.7):
	var tween:Tween = create_tween()
	tween.tween_property(fade_canvas_top,"size",Vector2(640,260),time)
	tween.parallel().tween_property(fade_canvas_mid,"size",Vector2(640,280), time)
	tween.parallel().tween_property(fade_canvas_bottom,"size",Vector2(640,260),time)
	tween.finished.connect(animation_fade_end)


func fadeOut(time:float = 0.7):
	var tween:Tween = create_tween()
	tween.tween_property(fade_canvas_top,"size",Vector2(0,260),time)
	tween.parallel().tween_property(fade_canvas_mid,"size",Vector2(0,280),time)
	tween.parallel().tween_property(fade_canvas_bottom,"size",Vector2(0,260),time)
	tween.finished.connect(animation_fade_end)


func animation_fade_end(): 
	fader_complete.emit()

func fade_with(callable:Callable) -> void:
	fadeIn()
	await fader_complete
	callable.call()
	await get_tree().create_timer(0.3).timeout
	fadeOut()
	await fader_complete
	
