extends Control


func _ready():
	$SlimeSouls.text = "Slime Souls: 0"
	$Health.value = 100


func _on_Repear_update_health(percent):
	$Health.value = percent


func _on_Repear_update_souls(souls):
	$SlimeSouls.text = "Slime Souls: " + str(souls)
