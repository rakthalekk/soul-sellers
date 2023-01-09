extends Node2D

const GHOST = preload("res://src/Ghost.tscn")

var spawn_rate = 6.0
var nightmode = false
var maxspawn = false

var rng = RandomNumberGenerator.new()

func _ready():
	if Global.coffin_unlock_flag:
		spawn_rate = 9.0
	elif Global.grave_unlock_flag:
		spawn_rate = 7.5
	rng.randomize()


func increase_spawn_rate():
	if spawn_rate > 1:
		spawn_rate -= 0.5


func night_mode():
	nightmode = true


func max_spawn_rate():
	 maxspawn = true


func spawn():
	var ghost = GHOST.instance()
	ghost.global_position = global_position
	get_parent().add_child(ghost)
	if maxspawn:
		if Global.coffin_unlock_flag:
			$SpawnRate.start(4)
		elif Global.grave_unlock_flag:
			$SpawnRate.start(3)
		else:
			$SpawnRate.start(2)
	elif nightmode:
		if Global.coffin_unlock_flag:
			$SpawnRate.start(7)
		elif Global.grave_unlock_flag:
			$SpawnRate.start(6)
		else:
			$SpawnRate.start(5)
	else:
		$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))


func _on_SpawnRate_timeout():
	$AnimationPlayer.play("shake")
