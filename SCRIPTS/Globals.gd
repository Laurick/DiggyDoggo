extends Node

const daylight_duration:float = 120
var current_daylight_duration:float = 120
var hole_size:int = 0

var consumed_room:Array = []
var inventory:Array[Pickable.ResourceType] = []
var current_day:int = -1
var score:int = 0
var level:int = 1

var run_lenght:float 
var number_of_hits:int

var sleep_message_seen:bool = false
var dig_message_seen:bool = false

enum GAME_MODE {arcade, time, demo}
var game_mode:Globals.GAME_MODE = GAME_MODE.arcade

func add_item(type:Pickable.ResourceType):
	match type:
		Pickable.ResourceType.coin:
			score += 100 
		Pickable.ResourceType.diamond:
			score += 500 
		Pickable.ResourceType.shovel:
			score += 50 
		Pickable.ResourceType.food:
			score += 10 
		Pickable.ResourceType.wood:
			score += 10 
	inventory.append(type)
	
func has_item(type:Pickable.ResourceType) -> bool:
	return inventory.has(type)

func remove_item(type):
	inventory.erase(type)

func reset():
	level = 1
	number_of_hits = 0
	hole_size = 0
	current_day = -1
	current_daylight_duration = daylight_duration
	consumed_room = []
	inventory.clear()
	sleep_message_seen = false
	dig_message_seen = false
	score = 0

func soft_reset():
	hole_size = 0
	current_daylight_duration = daylight_duration
	consumed_room = []
