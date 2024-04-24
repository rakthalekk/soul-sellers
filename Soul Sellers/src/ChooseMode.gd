extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Singleplayer.grab_focus()


func _on_Singleplayer_pressed():
	Global.multiplayer_joycons = false
	get_tree().change_scene("res://src/Shop.tscn")


func _on_Multiplayer_pressed():
	Global.multiplayer_joycons = true
	InputMap.action_erase_events("ui_left")
	InputMap.action_erase_events("ui_right")
	InputMap.action_erase_events("ui_up")
	InputMap.action_erase_events("ui_down")
	InputMap.action_erase_events("ui_accept")
	
	var left = InputEventJoypadMotion.new()
	left.axis = JOY_AXIS_1
	left.axis_value = -1.0
	var right = InputEventJoypadMotion.new()
	right.axis = JOY_AXIS_1
	right.axis_value = 1.0
	var up = InputEventJoypadMotion.new()
	up.axis = JOY_AXIS_0
	up.axis_value = 1.0
	var down = InputEventJoypadMotion.new()
	down.axis = JOY_AXIS_0
	down.axis_value = -1.0
	var accept = InputEventJoypadButton.new()
	accept.button_index = 13
	accept.pressed = true
	
	InputMap.action_add_event("ui_left", left)
	InputMap.action_add_event("ui_right", right)
	InputMap.action_add_event("ui_up", up)
	InputMap.action_add_event("ui_down", down)
	InputMap.action_add_event("ui_accept", accept)
	
	get_tree().change_scene("res://src/Shop.tscn")
