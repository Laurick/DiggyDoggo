extends Node2D

@export var damage_amount:int = 10
@onready var Area2d: Area2D = $PuddleSprite/Area2D

func _ready():
	Area2d.parent = self
