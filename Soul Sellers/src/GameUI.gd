extends Control

signal increase_spawn_rate

var next_increment = 50

func _ready():
	$Z/SlimeSouls.text = "Slime Souls: 0"
	$Z/Health.value = 100


func _process(delta):
	$Z/TimeLeft.text = "Time Left: " + str(round($GameTimer.time_left))
	if $GameTimer.time_left < next_increment:
		next_increment -= 10
		emit_signal("increase_spawn_rate")


func _on_Repear_update_health(percent):
	$Z/Health.value = percent


func _on_Repear_update_souls(souls):
	$Z/SlimeSouls.text = "Slime Souls: " + str(souls)
