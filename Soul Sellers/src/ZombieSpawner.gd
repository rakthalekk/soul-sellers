extends Node2D

const ZOMBIE = preload("res://src/Zombie.tscn")

var spawn_rate = 10.0
var nightmode = false
var maxspawn = false

var rng = RandomNumberGenerator.new()

func _ready():
	if !Global.grave_unlock_flag:
		visible = false
	rng.randomize()


func increase_spawn_rate():
	if spawn_rate > 1:
		spawn_rate -= 0.5


func night_mode():
	nightmode = true


func max_spawn_rate():
	 maxspawn = true


func spawn():
	var zombie = ZOMBIE.instance()
	zombie.global_position = global_position
	get_parent().add_child(zombie)
	if maxspawn:
		$SpawnRate.start(5)
	elif nightmode:
		$SpawnRate.start(8)
	else:
		$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))


func _on_SpawnRate_timeout():
	if !Global.grave_unlock_flag:
		return
	$AnimationPlayer.play("shake")
