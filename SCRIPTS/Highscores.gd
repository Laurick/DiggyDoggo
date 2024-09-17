extends Node

const path_arcade:String = "user://highscores_arcade.json"
const path_time:String = "user://highscores_time.json"

var arcade_scores:Array = []
var time_scores:Array = []

func _ready() -> void:
	if !FileAccess.file_exists(path_arcade):
		for index in 10:
			arcade_scores.append({"name":"AAA","score":1*index})
		arcade_scores.reverse()
		save_file(path_arcade, arcade_scores)
	else:
		arcade_scores = read_file(path_arcade)
	
	if !FileAccess.file_exists(path_time):
		for index in 10:
			time_scores.append({"name":"AAA","score":1*index})
		time_scores.reverse()
		save_file(path_time, time_scores)
	else:
		time_scores = read_file(path_time)

func read_file(path:String) -> Array:
	var content_file:String = FileAccess.open(path, FileAccess.READ).get_as_text()
	return JSON.parse_string(content_file)

func save_file(path:String, scores:Array):
	FileAccess.open(path, FileAccess.WRITE).store_string(JSON.stringify(scores))
	
func is_highscore(type:Globals.GAME_MODE, score:int) -> bool:
	match type:
		Globals.GAME_MODE.arcade:
			return arcade_scores.any(func (item): return item["score"] < score)
		Globals.GAME_MODE.time:
			return time_scores.any(func (item): return item["score"] < score)
	return false

func add_score(type:Globals.GAME_MODE, score:int, name_player:String):
	match type:
		Globals.GAME_MODE.arcade:
			for item in arcade_scores:
				if item["score"] < score:
					item["name"] = name_player
					item["score"] = score
					break
			save_file(path_arcade, arcade_scores)
		Globals.GAME_MODE.time:
			for item in time_scores:
				if item["score"] < score:
					item["name"] = name_player
					item["score"] = score
					break
			save_file(path_time, time_scores)

func reset():
	for index in 10:
		var item = arcade_scores[index]
		item["name"] = "AAA"
		item["score"] = index*1
	arcade_scores.reverse()
	save_file(path_arcade, arcade_scores)
	for index in 10:
		var item = time_scores[index]
		item["name"] = "AAA"
		item["score"] = index*1
	time_scores.reverse()
	save_file(path_time, time_scores)
