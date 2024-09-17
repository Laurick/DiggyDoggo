class_name CanvasController
extends CanvasLayer


@onready var food_sprite:TextureRect = $ColorRect/food_parent/food
@onready var wood_sprite:TextureRect = $ColorRect/wood_parent/wood
@onready var shovel_sprite:TextureRect = $ColorRect/shovel_parent/shovel
@onready var score_label:Label = $ColorRect/ControlScore/Score

@onready var progress_bar:Slider = $ColorRect/Control/ProgressBar
@onready var time_label:Label = $ColorRect/Time
@onready var timer:Timer = $"../DaylightTimer"

@onready var message_panel = $message_panel

@onready var time_anim = $ColorRect/time_anim

@onready var control = $ColorRect/Control

var menu_active: Control

const START_DAY_HOUR:int = 6
const END_DAY_HOUR:int = 20

var current_hour:int = 0
var current_minute:int = 0

signal on_message_closed(key:String)

func _process(_delta):
	if timer.is_stopped():
		return
	update_time_and_progress()

func _ready():
	message_panel.on_panel_closed.connect(message_closed)
	for item in Globals.inventory:
		pick_item(item)

func set_text_score():
	score_label.text = str(Globals.score)

func pick_item(item:Pickable.ResourceType):
	match item:
		Pickable.ResourceType.food:
			food_sprite.modulate.a = 1
		Pickable.ResourceType.wood:
			wood_sprite.modulate.a = 1
		Pickable.ResourceType.shovel:
			shovel_sprite.modulate.a = 1
	set_text_score()
	score_label.modulate = Colors.COLOR_GREEN
	create_tween().tween_property(score_label, "modulate", Color.WHITE, 0.5)

func remove_items():
	food_sprite.modulate.a = 0.25
	wood_sprite.modulate.a = 0.25
	shovel_sprite.modulate.a = 0.25

func remove_item(item:Pickable.ResourceType):
		match item:
			Pickable.ResourceType.food:
				food_sprite.modulate.a = 0.25
			Pickable.ResourceType.wood:
				wood_sprite.modulate.a = 0.25
			Pickable.ResourceType.shovel:
				shovel_sprite.modulate.a = 0.25

func get_completion_time() -> String:
	var days:int = Globals.current_day
	var progress:float = 100 - (timer.time_left / Globals.current_daylight_duration) * 100

	var total_minutes:int = int(lerp(START_DAY_HOUR * 60, END_DAY_HOUR * 60, progress / 100))
	current_hour = (total_minutes / 60) - START_DAY_HOUR
	current_minute = total_minutes % 60
	
	var victory_message = tr("VICTORY_MESSAGE")
	
	return victory_message %[days, current_hour, current_minute, Globals.number_of_hits]

func localize_and_show_message_record(score:int):
	match Globals.game_mode:
		Globals.GAME_MODE.arcade:
			message_panel.show_message_record(tr("RECORD_ARCADE")%[score], "RECORD_ARCADE")
		Globals.GAME_MODE.time:
			message_panel.show_message_record(tr("RECORD_TIME")%[score], "RECORD_TIME")

func show_message(message:String, message_key:String):
	message_panel.show_message(message, message_key)

func show_final_message():
	message_panel.show_final_message(get_completion_time(), "VICTORY_MESSAGE")

func message_closed(key:String): 
	on_message_closed.emit(key)

func update_time_and_progress():
	var progress:float = 100 - (timer.time_left / Globals.current_daylight_duration) * 100

	var total_minutes:int = int(lerp(START_DAY_HOUR * 60, END_DAY_HOUR * 60, progress / 100))
	current_hour = total_minutes / 60
	current_minute = total_minutes % 60
	
	var am_pm = "am"
	var hour_to_display = current_hour

	if current_hour >= 12:
		am_pm = "pm"
		if current_hour > 12:
			hour_to_display = current_hour - 12
	
	time_label.text = "%02d:%02d %s" % [hour_to_display, current_minute, am_pm]
	progress_bar.value = progress
	
	if progress < 80:
		control.modulate = Color.WHITE
	else:
		control.modulate = Colors.COLOR_RED

func flash_item(item:Pickable.ResourceType):
	match item:
			Pickable.ResourceType.food:
				flash_sprite(food_sprite)
			Pickable.ResourceType.wood:
				flash_sprite(wood_sprite)
			Pickable.ResourceType.shovel:
				flash_sprite(shovel_sprite)

func flash_sprite(texture:TextureRect):
	var tween = get_tree().create_tween()
	for n in 15:
		randomize()
		tween.tween_property(texture, "position", Vector2(randi_range(-10, 10), randi_range(-10, 10)), 0.05).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(texture, "position", Vector2.ZERO, 0.1)

func flash_time_left():
	time_anim.play("flash")
