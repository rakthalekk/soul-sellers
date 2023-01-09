extends Enemy

const PROJECTILE = preload("res://src/Projectile.tscn")

# Overrides constants
func _ready():
	HPMAX = 24.0
	SPEED = 150
	dmg = 3
	KBSPEED = 500
	KBFRICTION = 800
	SOUL = preload("res://src/ReaperEnemySoul.tscn")
	
	hp = HPMAX
	$SpawnSound.play()


func _process(delta):
	if !knockback:
		var dist = player.global_position - global_position
		if dist.length() > 250:
			direction = dist.normalized()
		elif dist.length() < 150:
			direction = -dist.normalized()
			$ProjectileTimer.stop()
		else:
			direction = Vector2.ZERO
			if $ProjectileTimer.is_stopped():
				$ProjectileTimer.start()
		
		velocity = direction * SPEED
		
		flip_sprite()
		
		if direction.y >= 0:
			$AnimationPlayer.play("float")
		else:
			$AnimationPlayer.play("float_back")


func hurt_sound():
	$HurtSound.play()


func _on_ProjectileTimer_timeout():
	if !knockback:
		var projectile = PROJECTILE.instance()
		projectile.global_position = global_position
		projectile.direction = (player.global_position - global_position).normalized()
		get_parent().add_child(projectile)
		$ProjectileSound.play()
