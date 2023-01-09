extends Enemy

const DIESOUND = preload("res://src/SkeletonDeathSound.tscn")

signal die

# Overrides constants
func _ready():
	HPMAX = 3.0
	SPEED = 200
	dmg = 1
	
	hp = HPMAX
	$SpawnSound.play()


func _process(delta):
	direction = (player.global_position - global_position).normalized()
	
	velocity = direction * SPEED
		
	flip_sprite()
	
	if direction.y >= 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("walk_back")


func create_soul():
	emit_signal("die")
	var diesound = DIESOUND.instance()
	get_parent().add_child(diesound)


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)
