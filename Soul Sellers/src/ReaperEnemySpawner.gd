extends Node2D

const GHOST = preload("res://src/ReaperEnemy.tscn")

const INITSPAWNRATE = 20.0
const NIGHTSPAWNRATE = 15.0
const MAXSPAWNRATE = 10.0
const INCREASERATE = (INITSPAWNRATE - NIGHTSPAWNRATE) / 6.0

var spawn_rate = INITSPAWNRATE
var nightmode = false
var maxspawn = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$SpawnRate.start(rng.randf_range(MAXSPAWNRATE, INITSPAWNRATE))


func increase_spawn_rate():
	if spawn_rate > NIGHTSPAWNRATE:
		spawn_rate -= INCREASERATE
		if Global.multiplayer_joycons:
			spawn_rate -= INCREASERATE


func night_mode():
	nightmode = true


func max_spawn_rate():
	 maxspawn = true


func spawn():
	var ghost = GHOST.instance()
	ghost.global_position = global_position
	get_parent().add_child(ghost)
	if maxspawn:
		$SpawnRate.start(MAXSPAWNRATE)
	elif nightmode:
		$SpawnRate.start(NIGHTSPAWNRATE)
	else:
		$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))


func _on_SpawnRate_timeout():
	$AnimationPlayer.play("shake")
