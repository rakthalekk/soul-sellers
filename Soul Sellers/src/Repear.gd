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
		
	if !Global.alt_controls:
		$Scythe.look_at(get_global_mouse_position())
		$CursorControl.look_at(get_global_mouse_position())
	else:
		var dir = Vector2.ZERO
		dir.x = Input.get_action_strength("attack_right") - Input.get_action_strength("attack_left")
		dir.y = Input.get_action_strength("attack_down") - Input.get_action_strength("attack_up")
		dir.normalized()
		if dir.length() != 0:
			$Scythe.look_at(global_position + dir * 500)
		
		if direction.length() != 0:
			$CursorControl.look_at(global_position + direction * 500)
	
	if ["dash", "dash_back"].has(anim_player.current_animation):
		$CursorControl/DashCursor.global_position = cursor_pos
	else:
		$CursorControl/DashCursor.position = Vector2(200, 2)
	
	move_and_slide(velocity)
	
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
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
		
	if !Global.alt_controls:
		if Input.is_action_just_pressed("attack") && $AttackCooldown.time_left == 0:
			dmg = BASEDMG
			play_attack_anim("attack")
			$AttackSound.play()
		
		if Input.is_action_just_released("attack") && $AttackCooldown.time_left == 0:
			if $AttackCharge.time_left == 0:
				dmg = BIGDMG
				play_attack_anim("big_attack")
				$BigAttackSound.play()
	else:
		var any_key_held = (Input.is_action_pressed("attack_up") || Input.is_action_pressed("attack_down") ||
				Input.is_action_pressed("attack_left") || Input.is_action_pressed("attack_right"))
		var non_up_held = (Input.is_action_pressed("attack_down") || Input.is_action_pressed("attack_left")
				|| Input.is_action_pressed("attack_right"))
		var non_down_held = (Input.is_action_pressed("attack_up") || Input.is_action_pressed("attack_left")
				|| Input.is_action_pressed("attack_right"))
		var non_left_held = (Input.is_action_pressed("attack_up") || Input.is_action_pressed("attack_down")
				|| Input.is_action_pressed("attack_right"))
		var non_right_held = (Input.is_action_pressed("attack_down") || Input.is_action_pressed("attack_left")
				|| Input.is_action_pressed("attack_up"))
		
		if ((Input.is_action_just_pressed("attack_up") && !non_up_held || Input.is_action_just_pressed("attack_down") && !non_down_held ||
				Input.is_action_just_pressed("attack_left") && !non_left_held || Input.is_action_just_pressed("attack_right") && !non_right_held)
				&& $AttackCooldown.time_left == 0):
			dmg = BASEDMG
			play_attack_anim("attack")
			$AttackSound.play()
		
		if ((Input.is_action_just_released("attack_up") || Input.is_action_just_released("attack_down") ||
				Input.is_action_just_released("attack_left") || Input.is_action_just_released("attack_right"))
				&& $AttackCooldown.time_left == 0 && $AttackCharge.time_left == 0 && !any_key_held):
			dmg = BIGDMG
			play_attack_anim("big_attack")
			$BigAttackSound.play()
			
	if Input.is_action_just_pressed("secondary_action") && $ActionCooldown.time_left == 0:
		if $AttackAnimation.is_playing():
			$AttackAnimation.play("RESET")
		
		action = true
		$ActionCooldown.start()
		$DashSound.play()
		
		cursor_pos = $CursorControl/DashCursor.global_position
		
		var dash_dir = mouse_dir
		if Global.alt_controls:
			dash_dir = (cursor_pos - global_position).normalized()
		
		if dash_dir.y >= 0:
			anim_player.play("dash")
		else:
			anim_player.play("dash_back")
		
		if dash_dir.x >= 0:
			$Sprite.flip_h = false
			$ScytheSprite.flip_h = false
		else:
			$Sprite.flip_h = true
			$ScytheSprite.flip_h = true
		
		direction = dash_dir
		
		velocity = direction * DASHSPEED
	
	if hp <= 0:
		emit_signal("die")
		$Sprite.modulate = Color(1, 0.2, 0.2)
		$DieSound.play()


func play_attack_anim(anim: String):
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	if Global.alt_controls:
		mouse_dir = ($CursorControl/DashCursor.global_position - global_position).normalized()
	
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


func end_action_back():
	action = false
	anim_player.play("idle_back")


func hurt(dmg: int):
	if !["hurt"].has($EffectsAnimation.current_animation) && !["dash", "dash_back"].has(anim_player.current_animation):
		hp -= dmg
		$EffectsAnimation.play("hurt")
		emit_signal("update_health", hp / HPMAX * 100)
		$HurtSound.play()


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
	$CursorControl/DashCursor.modulate = Color(1, 1, 1, 1)


func _on_AttackCharge_timeout():
	if !Global.alt_controls:
		if Input.is_action_pressed("attack"):
			$ChargeAttack.play()
			$ScytheAnimation.play("flash")
	else:
		if (Input.is_action_pressed("attack_up") || Input.is_action_pressed("attack_down") ||
				Input.is_action_pressed("attack_left") || Input.is_action_pressed("attack_right")):
			$ChargeAttack.play()
			$ScytheAnimation.play("flash")
