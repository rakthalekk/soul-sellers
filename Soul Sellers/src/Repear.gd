class_name Repear
extends KinematicBody2D

signal update_health(percent)
signal update_souls

const SPEED = 300
const DASHSPEED = 1200
const DASHFRICTION = 3000
const HPMAX = 10.0
const BASEDMG = 3.0
const BIGDMG = 5.0

var direction : Vector2 = Vector2.ZERO
var velocity :  Vector2 = Vector2.ZERO
var dash_pos : Vector2 = Vector2.ZERO

var action = false
var hp = HPMAX
var dmg = BASEDMG

var slime_souls = 0
var ghost_souls = 0

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !["dash", "dash_back"].has(anim_player.current_animation):
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DASHFRICTION)
		
		if global_position.distance_to(dash_pos) < 20:
			end_action()
	
	if !anim_player.current_animation == "attack":
		$Scythe.look_at(get_global_mouse_position())
	
	move_and_slide(velocity)
	
	if !action:
		if direction.y > 0:
			anim_player.play("idle")
		elif direction.y < 0:
			anim_player.play("idle_back")
		if direction.x < 0:
			$Sprite.flip_h = true
		elif direction.x > 0:
			$Sprite.flip_h = false
		
		var mouse_dir = (get_global_mouse_position() - global_position).normalized()
		
		if Input.is_action_just_pressed("attack") && $AttackCooldown.time_left == 0:
			dmg = BASEDMG
			play_attack_anim("attack")
		
		if Input.is_action_just_released("attack") && $AttackCooldown.time_left == 0:
			if $AttackCharge.time_left == 0:
				dmg = BIGDMG
				play_attack_anim("big_attack")
			
			$AttackCharge.stop()
			
		if Input.is_action_just_pressed("secondary_action") && $ActionCooldown.time_left == 0:
			action = true
			$ActionCooldown.start()
			set_collision_layer_bit(1, false)
			
			dash_pos = get_global_mouse_position()
			
			if mouse_dir.y >= 0:
				anim_player.play("dash")
			else:
				anim_player.play("dash_back")
			
			if mouse_dir.x >= 0:
				$Sprite.flip_h = false
			else:
				$Sprite.flip_h = true
			
			direction = mouse_dir
			velocity = direction * DASHSPEED
	
	if hp <= 0:
		queue_free()


func play_attack_anim(anim: String):
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	action = true
	$AttackCooldown.start()
	$AttackCharge.start()
	
	if mouse_dir.y >= 0:
		anim_player.play(anim)
	else:
		anim_player.play(anim + "_back")
	
	if mouse_dir.x >= 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
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
		slime_souls += 1
		emit_signal("update_souls")
	elif type == "ghost":
		ghost_souls += 1
		emit_signal("update_souls")


func _on_Scythe_body_entered(body):
	body.hurt(dmg)
