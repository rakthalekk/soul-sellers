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
		direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)


func _on_ProjectileTimer_timeout():
	if !knockback:
		var projectile = PROJECTILE.instance()
		projectile.global_position = global_position
		projectile.direction = direction
		get_parent().add_child(projectile)
