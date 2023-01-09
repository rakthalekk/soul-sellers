extends Enemy

const SKELETON = preload("res://src/Skeleton.tscn")

const SKELETON_SPAWNS = 5

var skeletons = 0
var skeletons_defeated = 0

# Overrides constants
func _ready():
	HPMAX = 12.0
	SPEED = 250
	dmg = 2
	KBSPEED = 700
	KBFRICTION = 1100
	SOUL = preload("res://src/VampireSoul.tscn")
	
	hp = HPMAX
	$SpawnSound.play()


func _process(delta):
	if !knockback:
		var dist = player.global_position - global_position
		
		if skeletons_defeated < SKELETON_SPAWNS:
			if dist.length() < 250:
				if abs(dist.y / dist.x) > 2:
					if global_position.x > 1000:
						direction = Vector2(-1, 0)
					elif global_position.x < 200:
						direction = Vector2(1, 0)
					else:
						direction = -dist.normalized()
				elif abs(dist.x / dist.y) > 2:
					if global_position.y > 475:
						direction = Vector2(0, -1)
					elif global_position.y < 300:
						direction = Vector2(0, 1)
					else:
						direction = -dist.normalized()
				else:
					direction = -dist.normalized()
			
			else:
				direction = Vector2.ZERO
		
		else:
			direction = dist.normalized()
		
		velocity = direction * SPEED
		
		flip_sprite()
		
		if direction.y >= 0:
			$AnimationPlayer.play("move")
		else:
			$AnimationPlayer.play("move_back")


func hurt_sound():
	$HurtSound.play()


func _on_SpawnTimer_timeout():
	skeletons += 1
	var skeleton = SKELETON.instance()
	skeleton.global_position = global_position
	get_parent().add_child(skeleton)
	skeleton.connect("die", self, "_on_Skeleton_die")
	if skeletons < SKELETON_SPAWNS:
		$SpawnTimer.start()


func _on_Skeleton_die():
	skeletons_defeated += 1
	if skeletons_defeated == SKELETON_SPAWNS:
		$Hitbox.set_collision_mask_bit(1, true)
		$HissSound.play()


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)
