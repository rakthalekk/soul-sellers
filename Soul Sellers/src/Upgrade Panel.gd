extends Node2D

signal start_quest
signal questing_done

onready var moneyText = $MarketUI/MoneyText
onready var slimeSoulText = $MarketUI/SlimeSoulText
onready var ghostSoulText = $MarketUI/GhostSoulText
onready var zombieSoulText = $MarketUI/ZombieSoulText
onready var vampireSoulText = $MarketUI/VampireSoulText
onready var reaperSoulText = $MarketUI/ReaperSoulText
onready var animationPlayer = $AnimationPlayer

var its_dialogue_time = false

func _ready():
	if Global.homing_souls_unlock_flag:
		$UpgradeCosts/Coin.visible = false
	if Global.grave_unlock_flag:
		$UpgradeCosts/Coin2.visible = false
	if Global.dmg_up_flag:
		$UpgradeCosts/Coin3.visible = false
	if Global.coffin_unlock_flag:
		$UpgradeCosts/Coin4.visible = false
	if Global.void_unlock_flag:
		$UpgradeCosts/Coin5.visible = false
	
	$"Quest Button".focus_neighbour_left = NodePath("../../ArenaButton")
	
	update_soul_counts()

func _process(delta):
	if (Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("ui_accept")) and its_dialogue_time:
		animationPlayer.play("move_onscreen")
		update_soul_counts()
		emit_signal("questing_done")

func update_soul_counts():
	update_money_count()
	slimeSoulText.text = str(Global.slime_souls)
	ghostSoulText.text = str(Global.ghost_souls)
	zombieSoulText.text = str(Global.zombie_souls)
	vampireSoulText.text = str(Global.vampire_souls)
	reaperSoulText.text = str(Global.reaper_souls)

func update_money_count():
	moneyText.text = str(Global.money_count)

func sell_souls():
	Global.money_count += clamp((Global.slime_souls * 4) + (Global.ghost_souls * 9) + (Global.zombie_souls * 15) + 
		(Global.vampire_souls * 30) + (Global.reaper_souls * 50), 0, 999999)
	Global.slime_souls = 0
	Global.ghost_souls = 0
	Global.zombie_souls = 0
	Global.vampire_souls = 0
	Global.reaper_souls = 0
	update_soul_counts()


func let_it_be_dialoging_time_once_again():
	its_dialogue_time = false


func _on_Quest_Button_pressed():
	if !its_dialogue_time:
		animationPlayer.play("move_offscreen")
		emit_signal("start_quest")
		its_dialogue_time = true

func _on_Sell_Button_pressed():
	sell_souls()

func _on_Homing_Souls_pressed():
	if Global.money_count < 50 or Global.homing_souls_unlock_flag:
		return
	Global.money_count -= 50
	Global.homing_souls_unlock_flag = true
	update_money_count()
	$UpgradeCosts/Coin.visible = false

func _on_Grave_Button_pressed():
	if Global.money_count < 250 or Global.grave_unlock_flag:
		return
	Global.money_count -= 250
	Global.grave_unlock_flag = true
	update_money_count()
	$UpgradeCosts/Coin2.visible = false
	Global.unlocked_spawners.append("zombie")

func _on_Void_Button_pressed():
	if Global.money_count < 1200 or Global.void_unlock_flag:
		return
	Global.money_count -= 1200
	Global.void_unlock_flag = true
	update_money_count()
	$UpgradeCosts/Coin5.visible = false
	Global.unlocked_spawners.append("reaper")

func _on_Coffin_Button_pressed():
	if Global.money_count < 800 or Global.coffin_unlock_flag:
		return
	Global.money_count -= 800
	Global.coffin_unlock_flag = true
	update_money_count()
	$UpgradeCosts/Coin4.visible = false
	Global.unlocked_spawners.append("vampire")


func _on_DmgButton_pressed():
	if Global.money_count < 400 or Global.dmg_up_flag:
		return
	Global.money_count -= 400
	Global.dmg_up_flag = true
	update_money_count()
	$UpgradeCosts/Coin3.visible = false
