extends Resource
class_name NPC

@export var npc_name = "NPC name"

@export var type : Types.NPCTypes

@export_multiline var initial_dialog = ""
@export_multiline var post_quest_dialog = ""
@export_multiline var translated_dialog = ""
@export_multiline var extra_dialog = ""

@export var quest_related : Quest
@export var quest_item : Item 
@export var reward_for_quest_item : Item #given after you give the quest item

@export var required_item : Item #used to unlock extra dialog or translation
@export var reward_item : Item #given after you talk to the npc
@export var paths_to_unlock: Dictionary #direction, Room\
@export var can_unlock_path : bool = true
@export var disappear_after_talk = false

var has_received_quest_item := false
var has_given_reward := false
var has_given_reward_of_quest := false
var has_talked_to_npc := false

func get_dialog() -> String:
	has_talked_to_npc = true
	if !has_received_quest_item:
		return initial_dialog
	else:
		return post_quest_dialog
		
func get_extra_dialog() -> String:
	has_talked_to_npc = true
	return extra_dialog
	
func get_post_dialog() -> String:
	has_talked_to_npc = true
	return post_quest_dialog

func get_translated_dialog() -> String:
	has_talked_to_npc = true
	return translated_dialog
		
func get_type() -> Types.NPCTypes:
	return type

func receive_quest_item():
	has_received_quest_item = true
	can_unlock_path = true
	
func give_reward_to_player() -> Item:
	if has_given_reward:
		return
	has_given_reward = true
	if reward_item == null:
		printerr("No reward item defined!")
	return reward_item
	
func give_reward_of_quest_to_player() -> Item:
	if has_given_reward_of_quest:
		return
	has_given_reward_of_quest = true
	if reward_for_quest_item == null:
		printerr("No reward item defined!")
	return reward_for_quest_item
	
