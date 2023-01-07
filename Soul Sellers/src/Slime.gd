extends Enemy

# Overrides constants
func _ready():
	HPMAX = 5.0
	SPEED = 300
	dmg = 1
	KBSPEED = 800
	KBFRICTION = 3000
	SOUL = preload("res://src/SlimeSoul.tscn")
	
	hp = HPMAX


func _on_HopCooldown_timeout():
	$HopDuration.start()
	direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED


func _on_HopDuration_timeout():
	$HopCooldown.start()
	velocity = Vector2.ZERO


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)


func hurt(dmg: int):
	hp -= dmg
	$HealthBar.value = hp / HPMAX * 100
	knockback = true
	$HopDuration.stop()
	$HopCooldown.start()
	direction = (global_position - player.global_position).normalized()
	velocity = direction * KBSPEED
