extends Node

const MAX_SIZE_HOLE:int = 2
var dungeon = {}

@onready var map_node:Node2D = $MapNode
@onready var daylight_timer:Timer = $DaylightTimer
@onready var player:Player = $Player
@onready var canvas_layer:CanvasController = $CanvasLayer

var message_is_open:bool = false
var finish_records:bool = false

const room_size:int = 160

func _ready():
	var seed_of_game
	match Globals.game_mode:
		Globals.GAME_MODE.demo:
			seed_of_game = 1234
			$CanvasLayer/ColorRect/Demo.visible = true
		Globals.GAME_MODE.arcade:
			seed_of_game = randi_range(-200, 200)
			$CanvasLayer/ColorRect/ControlScore.visible = true
		Globals.GAME_MODE.time:
			seed_of_game = randi_range(-100, 100)
		_:
			seed_of_game = 100
	dungeon = dungeon_generation.generate(seed_of_game)
	load_map()
	await get_tree().process_frame
	start_day()
	canvas_layer.set_text_score()
	player.on_hurt.connect(player_hurt)
	player.on_pick_object.connect(player_picked_object)
	player.on_action_area_entered.connect(action_area_entered)
	canvas_layer.on_message_closed.connect(on_message_closed)

func load_map():
	for i in dungeon.keys():
		map_node.add_child(dungeon[i])
		dungeon[i].position = i * room_size
		dungeon[i].setup()

func start_day():
	daylight_timer.stop()
	daylight_timer.wait_time = Globals.daylight_duration
	daylight_timer.start()
	if Globals.game_mode != Globals.GAME_MODE.demo:
		show_message("HOME_MESSAGE" if Globals.current_day == 0 else "SHINY_DAY")
	Globals.current_day += 1
	
func player_hurt(damage:int):
	if(daylight_timer.time_left - damage <= 0): game_over()
	else: 
		daylight_timer.start(daylight_timer.time_left - damage)
		canvas_layer.flash_time_left()
		AudioManager.play_hurt()
		Globals.number_of_hits += 1

func player_picked_object(type:Pickable.ResourceType, succeed):
	if succeed: 
		canvas_layer.pick_item(type)
		AudioManager.play_pick()
	else: 
		canvas_layer.flash_item(type)
		AudioManager.play_wrong()
	
func enter_home():
	AudioManager.fade_out()
	daylight_timer.paused = true
	
func exit_home():
	AudioManager.fade_in()
	daylight_timer.paused = false
	
func sleep(area:action_zone):
	if !Globals.sleep_message_seen: return
	if message_is_open: return
	show_message("SLEEPING_ACTION")
	Globals.remove_item(Pickable.ResourceType.food)
	Globals.remove_item(Pickable.ResourceType.wood)
	canvas_layer.remove_item(Pickable.ResourceType.food)
	canvas_layer.remove_item(Pickable.ResourceType.wood)
	area.do_action()
	Fader.fade_with(func (): reload_scene())


func dig(area:action_zone):
	if !Globals.dig_message_seen: return
	if message_is_open: return
	
	AudioManager.play_shovel()
	Globals.remove_item(Pickable.ResourceType.shovel)
	canvas_layer.remove_item(Pickable.ResourceType.shovel)
	player.hide_ui()
	Globals.hole_size += 1
	area.do_action()
	if(Globals.hole_size == MAX_SIZE_HOLE):
		if Globals.game_mode == Globals.GAME_MODE.time:
			canvas_layer.show_final_message()
			player.can_move = false
		if Globals.game_mode == Globals.GAME_MODE.arcade:
			Globals.soft_reset()
			Globals.level += 1
			Fader.fade_with(reload_scene)
	else:
		show_message("DIGGING_ACTION")
	
func action_area_entered(area:action_zone.zone_type):
	if Globals.game_mode != Globals.GAME_MODE.demo:
		if !Globals.sleep_message_seen and area == action_zone.zone_type.sleep:
			show_message("BED_MESSAGE")
			Globals.sleep_message_seen = true
		elif !Globals.dig_message_seen and area == action_zone.zone_type.dig:
			show_message("DIG_MESSAGE")
			Globals.dig_message_seen = true

func game_over():
	if Globals.game_mode == Globals.GAME_MODE.demo:
		Fader.fade_with(return_to_main)
		player.kill()
	else:
		show_message("DIE_MESSAGE")
		player.kill()

func show_records():
	player.pause_movement()
	canvas_layer.localize_and_show_message_record(compute_score())
	finish_records = true

func reload_scene():
	get_tree().reload_current_scene()

func show_message(message:String):
	player.pause_movement()
	canvas_layer.show_message(tr(message), message)
	message_is_open = true

func fade_out_ended():
	reload_scene()

func on_message_closed(key:String):
	message_is_open = false
	if player.is_dead:
		if finish_records:
			Fader.fade_with(return_to_main)
		elif (Globals.game_mode == Globals.GAME_MODE.arcade):
			var record = Highscores.is_highscore(Globals.game_mode, compute_score())
			if (!record):
				Fader.fade_with(return_to_main)
			else:
				show_records()
		else:
			Fader.fade_with(return_to_main)
	elif Globals.hole_size == MAX_SIZE_HOLE and Globals.game_mode == Globals.GAME_MODE.time:
		var record = Highscores.is_highscore(Globals.game_mode, compute_score())
		if (!record):
			Fader.fade_with(return_to_main)
		else:
			show_records()
	else:
		player.restore_movement()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and Globals.game_mode == Globals.GAME_MODE.demo:
		player.pause_movement()
		Fader.fade_with(return_to_main)

func return_to_main():
	Globals.reset()
	get_tree().change_scene_to_file("res://SCENES/main.tscn")

func _on_daylight_timer_timeout():
	game_over()

func compute_score()-> int:
	return Globals.score + ((10000-Globals.current_daylight_duration*10)+Globals.current_day*100)


var record_sended = false

func _on_send_record_pressed() -> void:
	if !record_sended:
		record_sended = true
		var user = $CanvasLayer/message_panel/record_message_border/message_canvas/MarginContainer/HBoxContainer/LetterButton.get_letter()+\
		$CanvasLayer/message_panel/record_message_border/message_canvas/MarginContainer/HBoxContainer/LetterButton2.get_letter()+\
		$CanvasLayer/message_panel/record_message_border/message_canvas/MarginContainer/HBoxContainer/LetterButton3.get_letter()
		Highscores.add_score(Globals.game_mode, compute_score(), user)
		await get_tree().create_timer(1).timeout
		Fader.fade_with(return_to_main)
