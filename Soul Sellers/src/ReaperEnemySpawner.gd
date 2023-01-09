extends Node2D

const GHOST = preload("res://src/ReaperEnemy.tscn")

var spawn_rate = 20.0
var nightmode = false
var maxspawn = false

var rng = RandomNumberGenerator.new()

func _ready():
	if !Global.void_unlock_flag:
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
	var ghost = GHOST.instance()
	ghost.global_position = global_position
	get_parent().add_child(ghost)
	if maxspawn:
		$SpawnRate.start(2)
	elif nightmode:
		$SpawnRate.start(5)
	else:
		$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))


func _on_SpawnRate_timeout():
	if !Global.void_unlock_flag:
		return
	$AnimationPlayer.play("shake")
