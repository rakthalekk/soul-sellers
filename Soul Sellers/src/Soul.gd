extends Area2D

export(String) var type
export(AudioStream) var sound

func _on_Soul_body_entered(body):
	body.give_soul(type)
	body.play_pickup_sound(sound)
	queue_free()
