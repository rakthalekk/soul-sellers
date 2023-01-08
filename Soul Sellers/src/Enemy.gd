class_name Enemy
extends KinematicBody2D

var HPMAX = 5.0
var SPEED = 300
var dmg = 1
var KBSPEED = 800
var KBFRICTION = 3000

var SOUL = preload("res://src/SlimeSoul.tscn")

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


func flip_sprite():
	if direction.x >= 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true


func hurt(dmg: int):
	hp -= dmg
	$HealthBar.value = hp / HPMAX * 100
	knockback = true
	direction = (global_position - player.global_position).normalized()
	velocity = direction * KBSPEED
