extends Control

export(Texture) var SLIME_SPAWNER_TEXTURE
export(Texture) var GHOST_SPAWNER_TEXTURE
export(Texture) var ZOMBIE_SPAWNER_TEXTURE
export(Texture) var VAMPIRE_SPAWNER_TEXTURE
export(Texture) var REAPER_SPAWNER_TEXTURE

onready var textures = {"slime": SLIME_SPAWNER_TEXTURE, "ghost": GHOST_SPAWNER_TEXTURE, "zombie": ZOMBIE_SPAWNER_TEXTURE,
		"vampire": VAMPIRE_SPAWNER_TEXTURE, "reaper": REAPER_SPAWNER_TEXTURE}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()
	update_spawners()


func update_spawners():
	$LeftSpawner/Spawner.texture = textures[Global.left_spawner]
	$LeftSpawner/Label.text = Global.left_spawner.capitalize()
	$MiddleSpawner/Spawner.texture = textures[Global.middle_spawner]
	$MiddleSpawner/Label.text = Global.middle_spawner.capitalize()
	$RightSpawner/Spawner.texture = textures[Global.right_spawner]
	$RightSpawner/Label.text = Global.right_spawner.capitalize()


func _on_LL_pressed():
	var idx = Global.unlocked_spawners.find(Global.left_spawner) - 1
	if idx == -1:
		idx = Global.unlocked_spawners.size() - 1
	
	Global.left_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_LR_pressed():
	var idx = Global.unlocked_spawners.find(Global.left_spawner) + 1
	if idx == Global.unlocked_spawners.size():
		idx = 0
	
	Global.left_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_ML_pressed():
	var idx = Global.unlocked_spawners.find(Global.middle_spawner) - 1
	if idx == -1:
		idx = Global.unlocked_spawners.size() - 1
	
	Global.middle_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_MR_pressed():
	var idx = Global.unlocked_spawners.find(Global.middle_spawner) + 1
	if idx == Global.unlocked_spawners.size():
		idx = 0
	
	Global.middle_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_RL_pressed():
	var idx = Global.unlocked_spawners.find(Global.right_spawner) - 1
	if idx == -1:
		idx = Global.unlocked_spawners.size() - 1
	
	Global.right_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_RR_pressed():
	var idx = Global.unlocked_spawners.find(Global.right_spawner) + 1
	if idx == Global.unlocked_spawners.size():
		idx = 0
	
	Global.right_spawner = Global.unlocked_spawners[idx]
	update_spawners()


func _on_Button_pressed():
	get_tree().change_scene("res://src/Main.tscn")
