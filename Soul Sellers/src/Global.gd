extends Node

var alt_controls = true
var dash_cursor_enabled = false

var grave_unlock_flag = false
var void_unlock_flag = false
var dmg_up_flag = false
var coffin_unlock_flag = false
var homing_souls_unlock_flag = false

var unlocked_spawners = ["slime", "ghost"]
#var unlocked_spawners = ["slime", "ghost", "zombie", "vampire", "reaper"]

var left_spawner = "slime"
var middle_spawner = "ghost"
var right_spawner = "slime"
#var left_spawner = "reaper"
#var middle_spawner = "reaper"
#var right_spawner = "reaper"

var first_time_shop = true
var quest_1_complete = false
var quest_2_complete = false
var quest_3_complete = false
var quest_4_complete = false
var quest_5_complete = false

var slime_souls = 0
var ghost_souls = 0
var zombie_souls = 0
var vampire_souls = 0
var reaper_souls = 0
var money_count = 0


var last_slime_num = 0
var last_ghost_num = 0
var last_zombie_num = 0
var last_vampire_num = 0
var last_reaper_num = 0


func set_last_num():
	last_slime_num = slime_souls
	last_ghost_num = ghost_souls
	last_zombie_num = zombie_souls
	last_vampire_num = vampire_souls
	last_reaper_num = reaper_souls


func reset_counts():
	slime_souls = last_slime_num
	ghost_souls = last_ghost_num
	zombie_souls = last_zombie_num
	vampire_souls = last_vampire_num
	reaper_souls = last_reaper_num
