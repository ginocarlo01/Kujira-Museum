extends Resource
class_name NPC

@export var npc_name = "NPC name"
@export_multiline var initial_dialog = ""
@export_multiline var post_quest_dialog = ""

@export var quest_item : Item
@export var reward_item : Item
@export var type : Types.NPCTypes

var has_received_quest_item := false

func get_dialog() -> String:
	if !has_received_quest_item:
		return initial_dialog
	else:
		return post_quest_dialog
		
func get_type() -> Types.NPCTypes:
	return type

func receive_quest_item():
	has_received_quest_item = true
	
func give_reward_to_player() -> Item:
	if reward_item == null:
		printerr("No reward item defined!")
	return reward_item
	
