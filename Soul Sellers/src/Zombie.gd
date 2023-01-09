extends Enemy

const TORSO = preload("res://src/ZombieTorso.tscn")
const LEGS = preload("res://src/ZombieLegs.tscn")

# Overrides constants
func _ready():
	HPMAX = 12.0
	SPEED = 100
	dmg = 2
	KBSPEED = 600
	KBFRICTION = 1500
	
	hp = HPMAX
	$SpawnSound.play()


func _process(delta):
	if !knockback:
		direction = (player.global_position - global_position).normalized()
		
		velocity = direction * SPEED
			
		flip_sprite()
		
		if direction.y >= 0:
			$AnimationPlayer.play("stumble")
		else:
			$AnimationPlayer.play("stumble_back")


func hurt_sound():
	$HurtSound.play()


func create_soul():
	var torso = TORSO.instance()
	torso.global_position = global_position
	torso.direction = direction.rotated(deg2rad(-20))
	torso.knockback = true
	get_parent().add_child(torso)
	
	var legs = LEGS.instance()
	legs.global_position = global_position
	legs.direction = direction.rotated(deg2rad(20))
	legs.knockback = true
	get_parent().add_child(legs)


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)
