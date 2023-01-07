extends Sprite

const SLIME = preload("res://src/Slime.tscn")


func _on_SpawnRate_timeout():
	var slime = SLIME.instance()
	slime.global_position = global_position
	get_parent().add_child(slime)
