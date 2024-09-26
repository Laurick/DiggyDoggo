extends Control

@onready var interaction_timer: Timer = $InteractionTimer
@onready var settings_menu: ColorRect = $SettingsMenu
@onready var highscore_arcade: ColorRect = $HighscoreArcade
@onready var highscore_time: ColorRect = $HighscoreTime
@onready var press_start: Label = $SplashScreen/PressStart
@onready var control_play: Control = $SplashScreen/Control
@onready var time_choose_label: TimedLabel = $SplashScreen/Control/Label
@onready var splash_screen: ColorRect = $SplashScreen
@onready var blink_arcade_component:BlinkComponent = $SplashScreen/Control/VBoxContainer/play_arcade/BlinkComponent
@onready var blink_time_component:BlinkComponent = $SplashScreen/Control/VBoxContainer/play_time/BlinkComponent2
@onready var animation_player: AnimationPlayer = $SplashScreen/AnimationPlayer

const TIME_HIGHSCORES = 10

enum MainMenuStates {INTRO, IDLE, HIGHSCORES_TIME, HIGHSCORES_ARCADE, DEMO, OPTIONS, START} 
var state:MainMenuStates = MainMenuStates.INTRO

func _ready() -> void:
	AudioManager.stop_music()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_exit"):
		get_tree().quit()
	if event.is_action_pressed("ui_help"):
		if state == MainMenuStates.IDLE:
			interaction_timer.paused = true
			state = MainMenuStates.OPTIONS
			Fader.fade_with(see_settings)
	if event.is_action_pressed("ui_start"):
		if animation_player.is_playing():
			# cancel animation
			animation_player.seek(2)
			intro_play_music()
			start_game()
		elif state == MainMenuStates.IDLE:
			start_game()
		elif state == MainMenuStates.HIGHSCORES_ARCADE or state == MainMenuStates.HIGHSCORES_TIME:
			Fader.fade_with(_exit_to_main)

func start_game():
	state = MainMenuStates.START
	AudioManager.play_confirmation()
	interaction_timer.paused = true
	var press_start_blink:BlinkComponent = $SplashScreen/PressStart/BlinkComponent3
	press_start_blink.blink()
	await press_start_blink.blink_finished
	press_start.visible = false
	control_play.visible = true
	control_play.get_child(0).get_child(0).grab_focus() # I know
	time_choose_label.start()


func restart_timer(time:int = 3):
	interaction_timer.paused = true
	interaction_timer.wait_time = time
	interaction_timer.start()
	interaction_timer.paused = false


func _on_interaction_timer_timeout() -> void:
	state = (state + 1) as MainMenuStates
	match state:
		MainMenuStates.HIGHSCORES_TIME:
			restart_timer(TIME_HIGHSCORES)
			Fader.fade_with(see_highscore_time)
		MainMenuStates.HIGHSCORES_ARCADE:
			restart_timer(TIME_HIGHSCORES)
			Fader.fade_with(see_highscore_arcade)
		MainMenuStates.DEMO:
			#restart_timer()
			#Fader.fade_with(_exit_to_main)
			Fader.fade_with(go_to_demo)


func see_settings() -> void:
	highscore_time.hide()
	highscore_arcade.hide()                          
	settings_menu.show()
	splash_screen.hide()


func see_highscore_time() -> void:
	splash_screen.hide()
	highscore_arcade.hide()
	highscore_time.show()
	$HighscoreTime/AnimationPlayer.play("player_move")

func see_highscore_arcade() -> void:
	splash_screen.hide()
	highscore_time.hide()
	highscore_arcade.show()

func go_to_demo() -> void:
	Globals.game_mode = Globals.GAME_MODE.demo
	get_tree().change_scene_to_file("res://SCENES/world.tscn")

func _on_play_time_pressed() -> void:
	if !time_choose_label.is_stopped():
		interaction_timer.paused = true
		time_choose_label.stop()
		AudioManager.play_confirmation()
		blink_time_component.blink()
		await blink_time_component.blink_finished
		Fader.fade_with(go_play_time)


func go_play_time():
	Globals.game_mode = Globals.GAME_MODE.time
	get_tree().change_scene_to_file("res://SCENES/world.tscn")


func _on_play_arcade_pressed() -> void:
	if !time_choose_label.is_stopped():
		interaction_timer.paused = true
		time_choose_label.stop()
		AudioManager.play_confirmation()
		blink_arcade_component.blink()
		await blink_arcade_component.blink_finished
		Fader.fade_with(go_play_arcade)


func go_play_arcade():
	Globals.game_mode = Globals.GAME_MODE.arcade
	get_tree().change_scene_to_file("res://SCENES/world.tscn")


func _on_settings_menu_on_settings_closed() -> void:
	Fader.fade_with(_exit_to_main)


func _exit_to_main():
	highscore_time.hide()
	highscore_arcade.hide()                          
	settings_menu.hide()
	splash_screen.show()
	state = MainMenuStates.IDLE


func _on_label_timeout() -> void:
	get_viewport().gui_get_focus_owner().pressed.emit()


# ANIMATION STUFF
func intro_play_music():
	state = MainMenuStates.IDLE
	AudioManager.play_music()

func intro_play_hit_sound():
	$SplashScreen/AudioStreamPlayer.stream = preload("res://AUDIO/intro.mp3")
	$SplashScreen/AudioStreamPlayer.play()

func intro_play_rock_sound():
	$SplashScreen/AudioStreamPlayer.stream = preload("res://AUDIO/rock_stones.wav")
	$SplashScreen/AudioStreamPlayer.play()


func _on_play_arcade_2_pressed() -> void:
	interaction_timer.paused = true
	Fader.fade_with(go_to_demo)


func _on_clean_button_pressed() -> void:
	Highscores.reset()
	Fader.fade_with(_exit_to_main)
