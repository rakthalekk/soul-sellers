extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Singleplayer.grab_focus()


func _on_Singleplayer_pressed():
	Global.multiplayer_joycons = false
	get_tree().change_scene("res://src/Shop.tscn")


func _on_Multiplayer_pressed():
	Global.multiplayer_joycons = true
	get_tree().change_scene("res://src/Shop.tscn")
