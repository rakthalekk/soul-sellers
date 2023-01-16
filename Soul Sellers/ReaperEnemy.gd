extends Enemy

const PROJECTILE = preload("res://src/Projectile.tscn")
const DEATHSOUND = preload("res://src/ReaperDeathSound.tscn")
const DASHSPEED = 1200
const DASHFRICTION = 3000
const BIGDMG = 3

var action = false
var dist = Vector2.ZERO

onready var anim_player = $AnimationPlayer

# Overrides constants
func _ready():
	HPMAX = 24.0
	SPEED = 200 #orginal was 250
	dmg = 2
	KBSPEED = 1000
	KBFRICTION = 3000
	SOUL = preload("res://src/ReaperEnemySoul.tscn")
	
	hp = HPMAX


func _process(delta):
	dist = player.global_position - global_position
	
	if !["dash", "dash_back"].has(anim_player.current_animation):
		direction = dist.normalized()
		
		if $DashTell.playing:
			if dist.length() > 125 && dist.length() < 150:
				direction = Vector2.ZERO
			elif dist.length() < 125:
				direction = -dist.normalized()
			velocity = direction * 300
		else:
			velocity = direction * SPEED
		
		if ["attack", "attack_back", "big_attack", "big_attack_back"].has(anim_player.current_animation):
			velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DASHFRICTION)
	
	flip_sprite()
	
	$Scythe.look_at(global_position + direction * 500)
	
	if $DashTell.playing:
		$ScytheSprite.modulate = Color(0.5, 0.5, 1)
	elif $AttackTell.playing:
		$ScytheSprite.modulate = Color(1, 0.5, 0.5)
	else:
		$ScytheSprite.modulate = Color(1, 1, 1)
	
	if !action:
		if dist.length() < 350 && $DashCooldown.time_left == 0:
			if !$DashTell.playing:
				$DashTell.play()
			
		elif dist.length() < 100 && $AttackCooldown.time_left == 0:
			if !$AttackTell.playing:
				$AttackTell.play()
			
		else:
			if direction.y >= 0:
				$AnimationPlayer.play("idle")
			else:
				$AnimationPlayer.play("idle_back")


func hurt(dmg: int):
	hp -= dmg
	$HealthBar.value = hp / HPMAX * 100
	direction = (global_position - player.global_position).normalized()
	velocity = direction * KBSPEED
	hurt_sound()


func end_action():
	action = false
	anim_player.play("idle")
	set_collision_layer_bit(2, true)


func end_action_back():
	action = false
	anim_player.play("idle_back")
	set_collision_layer_bit(2, true)


func end_dash():
	anim_player.play("big_attack")
	set_collision_layer_bit(2, true)


func end_dash_back():
	anim_player.play("big_attack_back")
	set_collision_layer_bit(2, true)


func hurt_sound():
	$HurtSound.play()


func create_soul():
	var soul = SOUL.instance()
	soul.global_position = global_position
	get_parent().add_child(soul)
	var sound = DEATHSOUND.instance()
	get_parent().add_child(sound)


func _on_ProjectileTimer_timeout():
	if !knockback:
		var projectile = PROJECTILE.instance()
		projectile.global_position = global_position
		projectile.direction = (player.global_position - global_position).normalized()
		get_parent().add_child(projectile)
		$ProjectileSound.play()


func _on_Scythe_body_entered(body):
	if ["big_attack", "big_attack_back"].has(anim_player.current_animation):
		body.hurt(BIGDMG)
	else:
		body.hurt(dmg)


func _on_DashTell_finished():
	direction = dist.normalized()
	action = true
	if dist.y > 0:
		anim_player.play("dash")
	else:
		anim_player.play("dash_back")
	$DashCooldown.start(5)
	velocity = direction * DASHSPEED


func _on_AttackTell_finished():
	direction = dist.normalized()
	action = true
	if dist.y > 0:
		anim_player.play("attack")
	else:
		anim_player.play("attack_back")
	velocity = Vector2.ZERO
	$AttackCooldown.start()

