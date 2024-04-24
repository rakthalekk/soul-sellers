extends Node2D

onready var speechBubble = $SpeechBubble
onready var speechBubbleTimer = $SpeechBubbleTimer
onready var animationPlayer = $AnimationPlayer
onready var colorRect = $ColorRect
onready var dialogue = $SpeechBubble/Dialogue
onready var dialogueNextIndicator = $SpeechBubble/DialogueNextIndicator

var dialogue_count = 0

func _ready():
	if Global.first_time_shop:
		first_time_shop_procedure()
	else:
		$ArenaButton.focus_neighbour_right = NodePath("../Upgrade Panel/Quest Button")
	
	$ArenaButton.grab_focus()

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
	if Global.slime_souls >= 15 and !Global.quest_1_complete:
		Global.money_count += 90
		Global.slime_souls -= 15
		Global.quest_1_complete = true
	elif Global.zombie_souls >= 5 and Global.ghost_souls >= 5 and !Global.quest_2_complete:
		Global.money_count += 175
		Global.zombie_souls -= 5
		Global.ghost_souls -=5
		Global.quest_2_complete = true
	elif Global.vampire_souls >= 3 and !Global.quest_3_complete:
		Global.money_count += 180
		Global.vampire_souls -= 3
		Global.quest_3_complete = true
	elif Global.slime_souls >= 60 and !Global.quest_4_complete:
		Global.money_count += 480
		Global.slime_souls -= 60
		Global.quest_4_complete = true
	elif Global.reaper_souls >= 1 and !Global.quest_5_complete:
		Global.money_count += 5000
		Global.reaper_souls -= 1
		Global.quest_5_complete = true

func quest_initiate():
	if !Global.quest_1_complete:
		dialogue.text = "Still need those 15 slime souls. Get em to me soon!"
	elif !Global.quest_2_complete:
		dialogue.text = "I need 5 zombie souls and 5 ghost souls. Thanks again!"
	elif !Global.quest_3_complete:
		dialogue.text = "Can you get me some vampire souls? 3 should do the trick"
	elif !Global.quest_4_complete:
		dialogue.text = "I'll pay 2 times the going rate for 60 slime souls"
	elif !Global.quest_5_complete:
		dialogue.text = "I need the soul of a grim reaper. Find one for me for me ASAP!"
	elif Global.quest_5_complete:
		dialogue.text = "No new requests from me!"
	else:
		dialogue.text = "How's the grim reaper hunt going?"

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://src/ChooseSpawners.tscn")

func _on_Upgrade_Panel_questing_done():
	speechBubble.visible = false

func first_time_shop_procedure():
	$"Upgrade Panel".visible = false
	speechBubble.visible = true
	first_time_dialogue(0)
	Global.first_time_shop = false

func first_time_dialogue(dialogue_count):
	if dialogue_count == 0:
		dialogue.text = "Hey there, I'm Ghostman - your soul-buying client!"
		$DialogueTimer.start()
	elif dialogue_count == 1:
		dialogue.text = "I'm comissioning you to fight in the arena and gather souls for me!" 
		$DialogueTimer.start()
	else:
		dialogue.text = "First, I'll be needing 15 slime souls. Go ahead and click the arena button to start!"
		return

func _on_DialogueTimer_timeout():
	dialogue_count += 1
	first_time_dialogue(dialogue_count)
