extends Node2D

signal start_quest

onready var moneyText = $MarketUI/MoneyText
onready var slimeSoulText = $MarketUI/SlimeSoulText
onready var ghostSoulText = $MarketUI/GhostSoulText
onready var zombieSoulText = $MarketUI/ZombieSoulText
onready var vampireSoulText = $MarketUI/VampireSoulText
onready var reaperSoulText = $MarketUI/ReaperSoulText
onready var animationPlayer = $AnimationPlayer

func _ready():
	update_soul_counts()

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
	Global.money_count = (Global.slime_souls * 4) + (Global.ghost_souls * 9) + (Global.zombie_souls * 15) + (Global.vampire_souls * 30) + (Global.reaper_souls * 50)
	Global.slime_souls = 0
	Global.ghost_souls = 0
	Global.zombie_souls = 0
	Global.vampire_souls = 0
	Global.reaper_souls = 0
	update_soul_counts()

func _on_Quest_Button_pressed():
	animationPlayer.play("move_offscreen")
	emit_signal("start_quest")

func _on_Sell_Button_pressed():
	sell_souls()

func _on_Homing_Souls_pressed():
	if Global.money_count < 50 or Global.homing_souls_unlock_flag:
		return
	Global.money_count -= 50
	Global.homing_souls_unlock_flag = true
	update_money_count()

func _on_Grave_Button_pressed():
	if Global.money_count < 250 or Global.grave_unlock_flag:
		return
	Global.money_count -= 250
	Global.grave_unlock_flag = true
	update_money_count()

func _on_Void_Button_pressed():
	if Global.money_count < 1200 or Global.void_unlock_flag:
		return
	Global.money_count -= 1200
	Global.void_unlock_flag = true
	update_money_count()

func _on_Coffin_Button_pressed():
	if Global.money_count < 800 or Global.coffin_unlock_flag:
		return
	Global.money_count -= 800
	Global.coffin_unlock_flag = true
	update_money_count()
