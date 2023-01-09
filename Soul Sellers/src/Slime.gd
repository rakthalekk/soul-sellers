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
	
	$SpawnSound.play()


func start_moving():
	direction = (player.global_position - global_position).normalized()
	if direction.y > 0:
		$AnimationPlayer.play("hop")
	else:
		$AnimationPlayer.play("hop_back")
	
	$HopSound.play()
	
	$AnimationPlayer.seek(0.201)
	
	flip_sprite()
	
	velocity = direction * SPEED


func hurt_sound():
	$HurtSound.play()


func stop_moving():
	velocity = Vector2.ZERO


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)

