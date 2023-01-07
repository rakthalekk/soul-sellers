extends Control

signal increase_spawn_rate
signal end_round

var next_increment = 50

onready var player : Repear = get_parent().get_node("YSort").get_node("Repear")

func _ready():
	$Z/Souls.text = "Slime Souls: 0\nGhost Souls: 0"
	$Z/Health.value = 100


func _process(delta):
	$Z/TimeLeft.text = "Time Left: " + str(round($GameTimer.time_left))
	if $GameTimer.time_left < next_increment:
		next_increment -= 10
		emit_signal("increase_spawn_rate")


func _on_Repear_update_health(percent):
	$Z/Health.value = percent


func _on_Repear_update_souls():
	$Z/Souls.text = "Slime Souls: " + str(player.slime_souls) + "\nGhost Souls: " + str(player.ghost_souls)


func _on_GameTimer_timeout():
	emit_signal("end_round")
