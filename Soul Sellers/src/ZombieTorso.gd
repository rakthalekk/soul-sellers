extends Enemy


# Overrides constants
func _ready():
	HPMAX = 8.0
	SPEED = 150
	dmg = 2
	KBSPEED = 600
	KBFRICTION = 1500
	SOUL = preload("res://src/ZombieSoul.tscn")
	
	hp = HPMAX
	velocity = direction * KBSPEED


func _process(delta):
	if !knockback:
		direction = (player.global_position - global_position).normalized()
		
		velocity = direction * SPEED
			
		flip_sprite()
		
		$AnimationPlayer.play("crawl")


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)


func _on_SpawnInvuln_timeout():
	set_collision_layer_bit(2, true)
