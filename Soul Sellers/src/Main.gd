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


func increase_spawn_rates():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.max_spawn_rate()


func _on_Gate_body_entered(body):
	change_to_shop()
