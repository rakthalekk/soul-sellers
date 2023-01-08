extends Area2D

var direction = Vector2.ZERO

var SPEED = 200
var dmg = 2


func _ready():
	look_at(global_position + direction)


func _physics_process(delta):
	position += direction * SPEED * delta


func _on_Projectile_body_entered(body):
	if body is Repear:
		body.hurt(dmg)
	
	queue_free()
