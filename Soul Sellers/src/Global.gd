extends Node

var alt_controls = false

var grave_unlock_flag = false
var void_unlock_flag = false
var dmg_up_flag = false
var coffin_unlock_flag = false
var homing_souls_unlock_flag = false
var final_mission_started = false
var final_mission_completed = false

var day_num = 1

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
