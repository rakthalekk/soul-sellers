extends Sprite

const GHOST = preload("res://src/Ghost.tscn")

var spawn_rate = 5.0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func increase_spawn_rate():
	if spawn_rate > 1:
		spawn_rate -= 0.5


func _on_SpawnRate_timeout():
	var ghost = GHOST.instance()
	ghost.global_position = global_position
	get_parent().add_child(ghost)
	$SpawnRate.start(rng.randf_range(spawn_rate - 1, spawn_rate + 3))
