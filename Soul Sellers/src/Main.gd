extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_GameUI_increase_spawn_rate():
	for spawner in get_tree().get_nodes_in_group("spawner"):
		spawner.increase_spawn_rate()
