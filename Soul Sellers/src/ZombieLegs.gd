extends Enemy


# Overrides constants
func _ready():
	HPMAX = 5.0
	SPEED = 200
	dmg = 1
	KBSPEED = 600
	KBFRICTION = 1500
	
	hp = HPMAX
	velocity = direction * KBSPEED


func _process(delta):
	if !knockback:
		direction = (player.global_position - global_position).normalized()
		
		velocity = direction * SPEED
			
		flip_sprite()
		
		if direction.y >= 0:
			$AnimationPlayer.play("stumble")
		else:
			$AnimationPlayer.play("stumble_back")


func create_soul():
	pass


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)


func _on_SpawnInvuln_timeout():
	set_collision_layer_bit(2, true)
