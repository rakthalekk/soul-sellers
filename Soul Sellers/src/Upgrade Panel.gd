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
	moneyText.text = str(Global.money_count)
	slimeSoulText.text = str(Global.slime_souls)
	ghostSoulText.text = str(Global.ghost_souls)
	zombieSoulText.text = str(Global.zombie_souls)
	vampireSoulText.text = str(Global.vampire_souls)
	reaperSoulText.text = str(Global.reaper_souls)

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
