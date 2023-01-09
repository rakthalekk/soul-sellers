extends Node2D

onready var speechBubble = $SpeechBubble
onready var speechBubbleTimer = $SpeechBubbleTimer
onready var animationPlayer = $AnimationPlayer
onready var colorRect = $ColorRect

func _ready():
	pass # Replace with function body.

func _on_Upgrade_Panel_start_quest():
	speechBubbleTimer.start()
	

func _on_SpeechBubbleTimer_timeout():
	speechBubble.visible = true

func _on_ArenaButton_pressed():
	colorRect.visible = true
	animationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://src/Main.tscn")
