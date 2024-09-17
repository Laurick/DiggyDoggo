extends Node

var left_step:bool = true

@onready var steps_l_sound:AudioStreamPlayer = $"steps-L"
@onready var steps_r_sound:AudioStreamPlayer = $"steps-R"
@onready var door_sound:AudioStreamPlayer = $door
@onready var pick_sound:AudioStreamPlayer = $pick
@onready var shovel_sound:AudioStreamPlayer = $shovel
@onready var hurt_sound:AudioStreamPlayer = $hurt
@onready var wrong_sound:AudioStreamPlayer = $wrong
@onready var interferences_sound:AudioStreamPlayer = $interferences
@onready var music_sound:AudioStreamPlayer = $music
@onready var confirmation: AudioStreamPlayer = $confirmation


var clips:Array[String] = ["res://MUSIC/DavidKBD - InterstellarPack - 01 - Interstellar.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 02 - Plasma Storm.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 03 - Temple of Madness.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 04 - Horsehead Nebula.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 05 - Forgotten Station.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 06 - Hope on the Horizon.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 07 - Electric Firework.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 08 - Synth Kobra.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 09 - Spiral of Plasma.ogg"]
var tween:Tween

var filter:AudioEffectLowPassFilter = null

func play_music():
	filter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	music_sound.stream = load(clips[randi_range(0, clips.size()-1)])
	music_sound.play()

func stop_music():
	music_sound.stop()

func fade_in():
	if tween:
		tween.kill()
	if get_tree() == null: return
	tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 20000, 0.4)

func fade_out():
	if tween:
		tween.kill()
	if get_tree() == null: return
	tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 2000, 0.4)
	
func play_pick():
	play_random_pitch(pick_sound)

func play_wrong():
	play_random_pitch(wrong_sound)

func play_shovel():
	for n in 4:
		play_random_pitch(shovel_sound)
		await get_tree().create_timer(0.2).timeout # Godot 4 yield syntax
		
func play_hurt():
	play_random_pitch(interferences_sound)
	play_random_pitch(hurt_sound)

func play_step():
	randomize()
	if left_step:
		steps_l_sound.pitch_scale = randf_range(0.7, 0.9)
		steps_l_sound.play()
	else:
		steps_r_sound.pitch_scale = randf_range(0.9, 1.2)
		steps_r_sound.play()

func play_door():
	door_sound.play()

func play_random_pitch(stream_player):
	randomize()
	stream_player.pitch_scale = randf_range(0.8, 1.2)
	stream_player.play()

func play_confirmation():
	play_random_pitch(confirmation)
