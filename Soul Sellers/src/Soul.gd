extends KinematicBody2D

const SPEED = 300

export(String) var type
export(AudioStream) var sound

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

var player : Repear

func _ready():
	var reaper1 = get_parent().get_node("Repear")
	if !Global.multiplayer_joycons:
		return reaper1
	
	var reaper2 = get_parent().get_node("Repear2")
	
	if position.distance_to(reaper1.position) < position.distance_to(reaper2.position):
		player = reaper1
	else:
		player = reaper2


func _process(delta):
	if !Global.homing_souls_unlock_flag:
		return
	direction = (player.global_position - global_position).normalized()
	velocity = SPEED * direction
	move_and_slide(velocity)

func _on_CollectionArea_body_entered(body):
	body.give_soul(type)
	body.play_pickup_sound(sound)
	queue_free()
