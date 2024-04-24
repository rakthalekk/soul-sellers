extends Control


func _ready():
	$PlayButton.grab_focus()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://src/ChooseMode.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
