extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var sprite_2d = $Path2D/PathFollow2D/SawSprite
@onready var area_2d: Area2D = $Path2D/PathFollow2D/SawSprite/Area2D
@export var damage_amount:int = 20
@export var movement_speed:float = 1
@export var rotation_speed:float = 800

func _ready():
	area_2d.parent = self

func _process(delta):
	path_follow_2d.progress_ratio += delta*movement_speed
	sprite_2d.rotation_degrees += delta*rotation_speed
