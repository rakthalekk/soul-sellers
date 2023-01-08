extends Enemy

const PROJECTILE = preload("res://src/Projectile.tscn")

# Overrides constants
func _ready():
	HPMAX = 8.0
	SPEED = 100
	dmg = 1
	KBSPEED = 500
	KBFRICTION = 800
	SOUL = preload("res://src/GhostSoul.tscn")
	
	hp = HPMAX


func _process(delta):
	if !knockback:
		var dist = player.global_pdddddosition - global_position
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


func _on_ProjectileTimer_timeout():
	if !knockback:
		var projectile = PROJECTILE.instance()
		projectile.global_position = global_position
		projectile.direction = (player.global_position - global_position).normalized()
		get_parent().add_child(projectile)
