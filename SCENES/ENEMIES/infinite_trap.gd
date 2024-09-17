extends Node2D

const time_between_states:int = 1

@export var damage_amount:int = 20
@export var start_delay:float = 0

@onready var area_2d: Area2D = $SpikesSprite/Area2D
@onready var spikes_sprite: AnimatedSprite2D = $SpikesSprite
@onready var collision_shape_2d: CollisionShape2D = $SpikesSprite/Area2D/CollisionShape2D

var time_passed:float = 0
var active = true
var started = false

func _ready():
	area_2d.parent = self

func _process(delta: float) -> void:
	if !started:
		time_passed += delta
		if time_passed >= start_delay:
			started = true
			time_passed = 0
			spikes_sprite.play("default")
	else:
		time_passed += delta
		if time_passed >= time_between_states:
			time_passed = 0
			active = !active
			collision_shape_2d.disabled = !active
