extends Sprite

const SLIME = preload("res://src/Slime.tscn")

func increase_spawn_rate():
	if $SpawnRate.wait_time > 1:
		$SpawnRate.wait_time -= 0.5

func _on_SpawnRate_timeout():
	var slime = SLIME.instance()
	slime.global_position = global_position
	get_parent().add_child(slime)
