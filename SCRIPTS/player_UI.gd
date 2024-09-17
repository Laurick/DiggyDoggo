class_name PlayerUI
extends Node2D

@onready var sleep_thoughts:Node = $sleep_thoughts
@onready var dig_thoughts:Node = $dig_thoughts
@onready var bubble_food:Sprite2D = $"sleep_thoughts/bubble-food"
@onready var bubble_wood:Sprite2D = $"sleep_thoughts/bubble-wood"
@onready var bubble_shovel:Sprite2D = $"dig_thoughts/bubble-shovel"

func show_sleep_stuff():
	bubble_food.show()
	bubble_wood.show()

	bubble_food.self_modulate = Colors.COLOR_GREEN if Globals.has_item(Pickable.ResourceType.food) else Colors.COLOR_RED
	bubble_wood.self_modulate = Colors.COLOR_GREEN if Globals.has_item(Pickable.ResourceType.wood) else Colors.COLOR_RED


func show_dig_stuff():
	bubble_shovel.show()
	bubble_shovel.self_modulate = Colors.COLOR_GREEN if Globals.has_item(Pickable.ResourceType.shovel) else Colors.COLOR_RED


func hide_sleep_stuff():
	bubble_food.hide()
	bubble_wood.hide()


func hide_dig_stuff():
	bubble_shovel.hide()
