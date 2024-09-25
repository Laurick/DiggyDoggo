class_name FileInputStream
extends Node

var file:FileAccess

func open_file_to_write(file_name:String):
	pass

func open_file_to_read(file_name:String):
	file = FileAccess.open(file_name, FileAccess.READ)

func read() -> Variant:
	var line = file.get_line()
	return str_to_var(line)

func write(message):
	file.store_string(var_to_str(message)+"\n")

func close_file():
	if file:
		file.close()
