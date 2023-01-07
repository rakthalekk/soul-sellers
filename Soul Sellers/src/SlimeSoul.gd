extends Area2D


func _on_SlimeSoul_body_entered(body):
	body.give_soul("slime")
	queue_free()
