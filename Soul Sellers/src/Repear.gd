class_name Repear
extends KinematicBody2D

signal update_health(percent)
signal update_souls(souls)

const SPEED = 300
const DASHSPEED = 1500
const DASHFRICTION = 5000
const HPMAX = 10.0

var direction : Vector2 = Vector2.ZERO
var velocity :  Vector2 = Vector2.ZERO

var action = false
var hp = HPMAX
var dmg = 3

var slime_souls = 0

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if anim_player.current_animation != "dash":
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DASHFRICTION)
	
	if !anim_player.current_animation == "attack":
		$Scythe.look_at(get_global_mouse_position())
	
	move_and_slide(velocity)
	
	if !action:
		if Input.is_action_just_pressed("attack") && $AttackCooldown.time_left == 0:
			action = true
			$AttackCooldown.start()
			anim_player.play("attack")
			var anim = anim_player.get_animation("attack")
			var track = anim.find_track("Scythe:rotation_degrees")
			anim.track_set_key_value(track, 0, $Scythe.rotation_degrees - 60)
			anim.track_set_key_value(track, 1, $Scythe.rotation_degrees + 60)
		if Input.is_action_just_pressed("secondary_action"):
			action = true
			anim_player.play("dash")
			direction = (get_global_mouse_position() - global_position).normalized()
			velocity = direction * DASHSPEED
	
	if !anim_player.is_playing():
		anim_player.play("idle")
	
	if hp <= 0:
		queue_free()


func end_action():
	action = false


func hurt(dmg: int):
	hp -= dmg
	$EffectsAnimation.play("hurt")
	emit_signal("update_health", hp / HPMAX * 100)


func give_soul(type: String):
	if type == "slime":
		slime_souls += 1
		emit_signal("update_souls", slime_souls)


func _on_Scythe_body_entered(body):
	body.hurt(dmg)
