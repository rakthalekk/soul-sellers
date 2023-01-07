extends Area2D

export(String) var type

func _on_Soul_body_entered(body):
	body.give_soul(type)
	queue_free()
