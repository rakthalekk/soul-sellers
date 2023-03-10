extends Control

signal increase_spawn_rate

var next_increment = 50

onready var player : Repear = get_parent().get_node("YSort").get_node("Repear")

func _ready():
	$Z/SlimeCount.text = str(Global.slime_souls)
	$Z/GhostCount.text = str(Global.ghost_souls)
	$Z/ZombieCount.text = str(Global.zombie_souls)
	$Z/VampireCount.text = str(Global.vampire_souls)
	$Z/ReaperCount.text = str(Global.reaper_souls)
	$Z/Health.value = 100


func _process(delta):
	if $GameTimer.time_left < next_increment:
		next_increment -= 10
		emit_signal("increase_spawn_rate")


func start_night_clock():
	$Z/AnimationPlayer.play("nighttime")


func enter_night():
	get_parent().tint()


func enter_berserk():
	get_parent().berserk()


func _on_Repear_update_health(percent):
	$Z/Health.value = percent


func _on_Repear_update_souls():
	#$Z/Souls.text = "Slime Souls: " + str(player.slime_souls) + "\nGhost Souls: " + str(player.ghost_souls)
	$Z/SlimeCount.text = str(Global.slime_souls)
	$Z/GhostCount.text = str(Global.ghost_souls)
	$Z/ZombieCount.text = str(Global.zombie_souls)
	$Z/VampireCount.text = str(Global.vampire_souls)
	$Z/ReaperCount.text = str(Global.reaper_souls)
