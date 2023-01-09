class_name Repear
extends KinematicBody2D

signal update_health(percent)
signal update_souls
signal die

const SPEED = 300
const DASHSPEED = 1200
const DASHFRICTION = 3000
const HPMAX = 10.0
var BASEDMG = 3.0
var BIGDMG = 5.0

var direction : Vector2 = Vector2.ZERO
var velocity :  Vector2 = Vector2.ZERO
var dash_pos : Vector2 = Vector2.ZERO
var cursor_pos : Vector2 = Vector2.ZERO

var action = false
var hp = HPMAX
var dmg = BASEDMG

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.dmg_up_flag:
		BASEDMG = 5.0
		BIGDMG = 8.0
		dmg = BASEDMG


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !["dash", "dash_back"].has(anim_player.current_animation):
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DASHFRICTION)
		
	
	$Scythe.look_at(get_global_mouse_position())
	
	if ["dash", "dash_back"].has(anim_player.current_animation):
		$Scythe/Cursor.global_position = cursor_pos
	else:
		$Scythe/Cursor.position = Vector2(200, 2)
	
	move_and_slide(velocity)
	
	if !action:
		if direction.y > 0:
			anim_player.play("idle")
		elif direction.y < 0:
			anim_player.play("idle_back")
		if direction.x < 0:
			$Sprite.flip_h = true
			$ScytheSprite.flip_h = true
		elif direction.x > 0:
			$Sprite.flip_h = false
			$ScytheSprite.flip_h = false
		
		var mouse_dir = (get_global_mouse_position() - global_position).normalized()
		
		if Input.is_action_just_pressed("attack") && $AttackCooldown.time_left == 0:
			dmg = BASEDMG
			play_attack_anim("attack")
			$AttackSound.play()
		
		if Input.is_action_just_released("attack") && $AttackCooldown.time_left == 0:
			if $AttackCharge.time_left == 0:
				dmg = BIGDMG
				play_attack_anim("big_attack")
				$BigAttackSound.play()
			
		if Input.is_action_just_pressed("secondary_action") && $ActionCooldown.time_left == 0:
			action = true
			$ActionCooldown.start()
			set_collision_layer_bit(1, false)
			
			dash_pos = get_global_mouse_position()
			cursor_pos = $Scythe/Cursor.global_position
			
			if mouse_dir.y >= 0:
				anim_player.play("dash")
			else:
				anim_player.play("dash_back")
			
			if mouse_dir.x >= 0:
				$Sprite.flip_h = false
				$ScytheSprite.flip_h = false
			else:
				$Sprite.flip_h = true
				$ScytheSprite.flip_h = true
			
			direction = mouse_dir
			velocity = direction * DASHSPEED
	
	if hp <= 0:
		emit_signal("die")
		$Sprite.modulate = Color(1, 0.2, 0.2)
		$DieSound.play()


func play_attack_anim(anim: String):
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	action = true
	$AttackCooldown.start()
	$AttackCharge.start()
	
	if mouse_dir.y >= 0:
		$AttackAnimation.play(anim)
		anim_player.play("idle")
	else:
		$AttackAnimation.play(anim + "_back")
		anim_player.play("idle_back")
	
	if mouse_dir.x >= 0:
		$Sprite.flip_h = false
		$ScytheSprite.flip_h = false
	else:
		$Sprite.flip_h = true
		$ScytheSprite.flip_h = true
	
	if mouse_dir.x >= 0 && mouse_dir.y < 0 || mouse_dir.x < 0 && mouse_dir.y >= 0:
		$Scythe/Sprite.flip_v = true
	else:
		$Scythe/Sprite.flip_v = false


func end_action():
	action = false
	anim_player.play("idle")
	set_collision_layer_bit(1, true)


func end_action_back():
	action = false
	anim_player.play("idle_back")
	set_collision_layer_bit(1, true)


func hurt(dmg: int):
	if !["hurt"].has($EffectsAnimation.current_animation):
		hp -= dmg
		$EffectsAnimation.play("hurt")
		emit_signal("update_health", hp / HPMAX * 100)


func give_soul(type: String):
	if type == "slime":
		Global.slime_souls += 1
	elif type == "ghost":
		Global.ghost_souls += 1
	elif type == "zombie":
		Global.zombie_souls += 1
	elif type == "vampire":
		Global.vampire_souls += 1
	elif type == "reaper":
		Global.reaper_souls += 1
	
	emit_signal("update_souls")


func play_pickup_sound(sound):
	$SoulPickupSound.stream = sound
	$SoulPickupSound.play()


func _on_Scythe_body_entered(body):
	body.hurt(dmg)


func _on_ActionCooldown_timeout():
	$Scythe/Cursor.modulate = Color(1, 1, 1, 1)


func _on_AttackCharge_timeout():
	if Input.is_action_pressed("attack"):
		$ChargeAttack.play()
		$ScytheAnimation.play("flash")
