extends Node

var rooms:Array = []

var generation_chance:int = 20

func generate(room_seed):
	rooms.clear()
	if rooms.is_empty(): preload_all_scenes()
	seed(room_seed)

	var dungeon = generate_dungeon(len(rooms))
	
	while(!is_interesting(dungeon)):
		for i in dungeon.keys():
			dungeon.get(i).queue_free()
		randomize()
		dungeon = generate_dungeon(len(rooms))
	return dungeon

func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1

func is_interesting(dungeon):
	var room_with_three = 0
	for i in dungeon.keys():
		if(dungeon.get(i).number_of_connections >= 3):
			room_with_three += 1
	return room_with_three >= 2
	
func generate_dungeon(size:int) -> Dictionary:
	var dungeon:Dictionary = {}
	dungeon[Vector2(0,0)] = instantiate_new_room(0)
	while(dungeon.keys().size() < size):
		for i in dungeon.keys():
			if(dungeon.keys().size() == size):
				return dungeon
			if(randi_range(0,100) < generation_chance):
				var direction = randi_range(0,4)
				if(direction < 1):
					var new_room_position = i + Vector2(1, 0)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = instantiate_new_room(dungeon.keys().size())
					if(dungeon.get(i).connected_rooms.get(Vector2(1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(1, 0))
				elif(direction < 2):
					var new_room_position = i + Vector2(-1, 0)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = instantiate_new_room(dungeon.keys().size())
					if(dungeon.get(i).connected_rooms.get(Vector2(-1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(-1, 0))
				elif(direction < 3):
					var new_room_position = i + Vector2(0, 1)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = instantiate_new_room(dungeon.keys().size())
					if(dungeon.get(i).connected_rooms.get(Vector2(0, 1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, 1))
				elif(direction < 4):
					var new_room_position = i + Vector2(0, -1)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = instantiate_new_room(dungeon.keys().size())
					if(dungeon.get(i).connected_rooms.get(Vector2(0, -1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, -1))
	return dungeon

func instantiate_new_room(index:int) -> Node2D:
	return rooms[index].instantiate()

func get_theme_by_level(level:int):
	match level:
		1:
			return "1"
		2,3,4:
			return "2-4"
		_:
			return "plus5"

func preload_all_scenes():
	var directory_path = "res://SCENES/Levels/"+get_theme_by_level(Globals.level)+"/"
	var dir = DirAccess.open(directory_path)
	rooms.clear()
	if dir:
		rooms.append(load("res://SCENES/Levels/00-home_room.tscn"))
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (file_name.ends_with(".remap")):
				file_name = file_name.replace(".remap","")
			if Globals.game_mode == Globals.GAME_MODE.time:
				if !(file_name.contains("coin") or file_name.contains("diamond")):
					rooms.append(load(directory_path+file_name))
			else:
				rooms.append(load(directory_path+file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
