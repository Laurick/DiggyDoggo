class_name HighscoreLabel
extends Control

@onready var name_label: Label = $HBoxContainer/NameLabel
@onready var score_label: Label = $HBoxContainer/ScoreLabel
@onready var position_label: Label = $HBoxContainer/PositionLabel

var data_position_index:String
var data_name_player:String
var data_score:String


func _ready() -> void:
	var data_color:Color = get_color_label(int(data_position_index))
	position_label.text = data_position_index
	position_label.add_theme_color_override("font_color", data_color)
	name_label.text = data_name_player
	name_label.add_theme_color_override("font_color", data_color)
	score_label.text = data_score
	score_label.add_theme_color_override("font_color", data_color)


func get_color_label(color:int):
	match color:
		1: return Color.YELLOW
		2: return Color.YELLOW
		3: return Color.YELLOW
		10: return Colors.COLOR_RED
		_: return Color.WHITE
		
func setup(position_index:String, name_player:String, score:String):
	data_position_index = position_index
	data_name_player = name_player
	data_score = score
