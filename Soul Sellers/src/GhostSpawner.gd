extends Node2D

const GHOST = preload("res://src/Ghost.tscn")

var spawn_rate = 7.0
var maxspawn = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func increase_spawn_rate():
	if spawn_rate > 1:
		spawn_rate -= 0.5


func max_spawn_rate():
	 maxspawn = true


func spawn():
	var ghost = GHOST.instance()
	ghost.global_position = global_position
	get_parent().add_child(ghost)
	if !maxspawn:
		$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))
	else:
		$SpawnRate.start(1.5)


func _on_SpawnRate_timeout():
	$AnimationPlayer.play("shake")
