extends Node2D

onready var speechBubble = $SpeechBubble
onready var speechBubbleTimer = $SpeechBubbleTimer
onready var animationPlayer = $AnimationPlayer
onready var colorRect = $ColorRect
onready var dialogue = $SpeechBubble/Dialogue

func _ready():
	pass # Replace with function body.

func _on_Upgrade_Panel_start_quest():
	speechBubbleTimer.paused = false
	speechBubbleTimer.start()

func _on_SpeechBubbleTimer_timeout():
	speechBubble.visible = true
	speechBubbleTimer.paused = true
	check_quest_completion()
	quest_initiate()

func _on_ArenaButton_pressed():
	colorRect.visible = true
	animationPlayer.play("fade_out")

func check_quest_completion():
	if Global.day_num >= 2 and Global.slime_souls >= 15:
		Global.money_count += 90
		Global.slime_souls -= 15
	if Global.day_num >= 3 and Global.zombie_souls >= 5 and Global.ghost_souls >= 5:
		Global.money_count += 175
		Global.zombie_souls -= 5
		Global.ghost_souls -=5
	if Global.day_num >=4 and Global.vampire_souls >= 3:
		Global.money_count += 180
		Global.vampire_souls -= 3
	if Global.day_num >= 5 and Global.slime_souls >= 60:
		Global.money_count += 480
		Global.slime_souls -= 60
	if Global.day_num >= 6 and Global.reaper_souls >= 1:
		Global.money_count += 5000
		Global.reaper_souls -= 1

func quest_initiate():
	if Global.day_num == 1:
		dialogue.text = "I need 15 slime souls. Remember to check in with me before you sell tomorrow!"
	elif Global.day_num == 2:
		dialogue.text = "I need 5 zombie souls and 5 ghost souls. Thanks again!"
	elif Global.day_num == 3:
		dialogue.text = "Can you get me some vampire souls? 3 should do the trick"
	elif Global.day_num == 4:
		dialogue.text = "I'll pay 2 times the going rate for 60 slime souls"
	elif Global.day_num == 5:
		dialogue.text = "I need the soul of a grim reaper. Find one for me for me ASAP!"
	elif Global.final_mission_completed:
		dialogue.text = "No new requests from me!"
	else:
		dialogue.text = "How's the grim reaper hunt going?"

func _on_AnimationPlayer_animation_finished(anim_name):
	Global.day_num += 1
	get_tree().change_scene("res://src/Main.tscn")

func _on_Upgrade_Panel_questing_done():
	speechBubble.visible = false
