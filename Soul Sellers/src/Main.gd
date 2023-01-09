extends Node2D


func _on_GameUI_increase_spawn_rate():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.increase_spawn_rate()


func _on_GameUI_end_round():
	$TimeUp.visible = true
	get_tree().paused = true
	$TimeUp/AnimationPlayer.play("fade out")


func change_to_shop():
	get_tree().paused = false
	get_tree().change_scene("res://src/Shop.tscn")


func tint():
	$CanvasModulate/AnimationPlayer.play("tint")
	$Bong.play()


func increase_spawn_rates():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.max_spawn_rate()


func _on_Gate_body_entered(body):
	$E.show()


func _on_Gate_body_exited(body):
	$E.hide()


func _process(delta):
	if Input.is_action_just_pressed("exit"):
		if $Gate.get_overlapping_bodies().size() > 0:
			_on_GameUI_end_round()
