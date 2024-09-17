extends Area2D

class_name action_zone

@export var type:zone_type

@onready var action_sprite:Sprite2D = $Node2D/Action

enum zone_type {
	sleep,
	dig}

func do_action():
	match type:
		zone_type.sleep:
			var anim_fire = $AnimatedFire as AnimatedSprite2D
			anim_fire.animation = "on"
			$Bed/Animatedbed.show()
		zone_type.dig:
			$hole.update_visuals()
	hide_action()

func show_action():
	match type:
		zone_type.sleep:
			if !Globals.has_item(Pickable.ResourceType.food) || !Globals.has_item(Pickable.ResourceType.wood): return
		zone_type.dig:
			if !Globals.has_item(Pickable.ResourceType.shovel) : return
	action_sprite.visible = true

func hide_action():
	action_sprite.visible = false
