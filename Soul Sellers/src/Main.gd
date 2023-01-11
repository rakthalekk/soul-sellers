extends Node2D


func _ready():
	Global.set_last_num()


func _on_GameUI_increase_spawn_rate():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.increase_spawn_rate()


func end_round():
	$TimeUp.visible = true
	get_tree().paused = true
	$TimeUp/AnimationPlayer.play("fade out")


func change_to_shop():
	get_tree().paused = false
	get_tree().change_scene("res://src/Shop.tscn")


func tint():
	$CanvasModulate/AnimationPlayer.play("tint")
	$Bong.play()


func berserk():
	$CanvasModulate/AnimationPlayer.play("dark tint")
	$Bong.play()


func increase_spawn_rates():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.night_mode()
	
	$GameUI.start_night_clock()


func annihilate_spawn_rates():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.max_spawn_rate()


func _on_Gate_body_entered(body):
	$E.show()


func _on_Gate_body_exited(body):
	$E.hide()


func _process(delta):
	if Input.is_action_just_pressed("exit"):
		if $Gate.get_overlapping_bodies().size() > 0:
			end_round()


func _on_Repear_die():
	Global.slime_souls = Global.slime_souls - (Global.slime_souls - Global.last_slime_num) / 2
	Global.ghost_souls = Global.ghost_souls - (Global.ghost_souls - Global.last_ghost_num) / 2
	Global.zombie_souls = Global.zombie_souls - (Global.zombie_souls - Global.last_zombie_num) / 2
	Global.vampire_souls = Global.vampire_souls - (Global.vampire_souls - Global.last_vampire_num) / 2
	Global.reaper_souls = Global.reaper_souls - (Global.reaper_souls - Global.last_reaper_num) / 2
	end_round()
