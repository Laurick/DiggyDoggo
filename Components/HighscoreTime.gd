class_name HighscoreTime
extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready():
	var scene:PackedScene = preload("res://Components/HighscoreLabel.tscn")
	var index = 1
	for score in Highscores.time_scores:
		var instance = scene.instantiate()
		instance.setup(str(index), score["name"], str(score["score"]))
		v_box_container.add_child(instance)
		index += 1
