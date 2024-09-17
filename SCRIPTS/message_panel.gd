extends Control

signal on_panel_closed(key:String)

var message_is_visible = false
var message_visible:Node
var key:String

func _process(_delta):
	if !message_is_visible: return
	if Input.is_action_just_pressed("ui_accept"): hide_message()

func hide_message():
	message_visible.hide()
	message_is_visible = false
	on_panel_closed.emit(key)

func show_message(message:String, p_key:String):
	message_visible = $message_border
	key = p_key
	message_visible.show()
	$message_border/message_canvas/text.text = message
	$message_border/message_canvas/Control/action_image.visible = false
	await get_tree().create_timer(1).timeout
	$message_border/message_canvas/Control/action_image.visible = true
	message_is_visible = true
	
	
func show_final_message(message:String, p_key:String):
	message_visible = $congratulations_message
	key = p_key
	message_visible.show()
	$congratulations_message/message_canvas/text.text = message
	$congratulations_message/message_canvas/fireworks_blue.emitting = true
	$congratulations_message/message_canvas/fireworks_red.emitting = true
	$congratulations_message/message_canvas/fireworks_green.emitting = true
	$congratulations_message/Control/action_image.visible = false
	await get_tree().create_timer(1).timeout
	$congratulations_message/Control/action_image.visible = true
	message_is_visible = true


func show_message_record(message:String, p_key:String):
	message_visible = $record_message_border
	key = p_key
	message_visible.show()
	$record_message_border/message_canvas/text.text = message
	$congratulations_message/Control/action_image.visible = false
	$record_message_border/message_canvas/MarginContainer/HBoxContainer/LetterButton.grab_focus()


func _on_send_record_pressed() -> void:
	var blink_component:BlinkComponent = $record_message_border/message_canvas/MarginContainer/HBoxContainer/send_record/BlinkComponent2
	blink_component.blink()
	await blink_component.blink_finished
	message_visible.hide()
	message_is_visible = false
