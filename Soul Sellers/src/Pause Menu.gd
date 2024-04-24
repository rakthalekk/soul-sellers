extends Control


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		input_pause()


func input_pause():
	$ResumeButton.grab_focus()
	if !get_tree().paused:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false


func _on_ResumeButton_pressed():
	hide()
	get_tree().paused = false


func _on_Shop_pressed():
	Global.reset_counts()
	get_tree().paused = false
	get_tree().change_scene("res://src/Shop.tscn")


func _on_Exit_pressed():
	Global.reset_counts()
	get_tree().paused = false
	get_tree().change_scene("res://src/MainMenu.tscn")
