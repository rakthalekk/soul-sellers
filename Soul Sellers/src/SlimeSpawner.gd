extends Node2D

const SLIME = preload("res://src/Slime.tscn")

var spawn_rate = 5.0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func increase_spawn_rate():
	if spawn_rate > 1:
		spawn_rate -= 0.5


func spawn():
	var slime = SLIME.instance()
	slime.global_position = global_position
	get_parent().add_child(slime)
	$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))


func _on_SpawnRate_timeout():
	$AnimationPlayer.play("shake")
