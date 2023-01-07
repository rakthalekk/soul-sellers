extends KinematicBody2D

const HPMAX = 5.0
const SPEED = 300
const dmg = 1
const KBSPEED = 800
const KBFRICTION = 3000

const SOUL = preload("res://src/SlimeSoul.tscn")

var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO

var player : Repear
var hp = HPMAX
var knockback = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Repear")
	$HealthBar.value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if knockback:
		velocity = velocity.move_toward(Vector2.ZERO, delta * KBFRICTION)
		if velocity.length() == 0:
			knockback = false
	
	move_and_slide(velocity)
	
	if hp <= 0:
		var soul = SOUL.instance()
		soul.global_position = global_position
		get_parent().add_child(soul)
		queue_free()


func _on_HopCooldown_timeout():
	$HopDuration.start()
	direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED


func _on_HopDuration_timeout():
	$HopCooldown.start()
	velocity = Vector2.ZERO


func _on_Hitbox_body_entered(body):
	body.hurt(dmg)


func hurt(dmg: int):
	hp -= dmg
	$HealthBar.value = hp / HPMAX * 100
	knockback = true
	$HopDuration.stop()
	$HopCooldown.start()
	direction = (global_position - player.global_position).normalized()
	velocity = direction * KBSPEED
