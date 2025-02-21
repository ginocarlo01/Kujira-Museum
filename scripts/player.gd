extends Node
class_name Player

var inventory : Array = []
var quests : Array = []

func take_item(item : Item):
	inventory.append(item)
	
func drop_item(item : Item):
	inventory.erase(item)
	
func add_quest(quest : Quest) -> String:
	quests.append(quest)
	return "A missão " + Types.wrap_mission_text(quest.quest_name) + " foi adicionada."
	
func remove_quest(quest : Quest):
	quests.erase(quest)
	
func get_inventory() -> String:
	if inventory.size() == 0:
		return "Seu inventário está vazio."
	
	var inventory_description = ""
	
	for i in inventory:
		if inventory_description != "":
			inventory_description += ", "	
		inventory_description += i.item_name + " "	
		
	return "Os itens que você tem são: " + inventory_description
	
func get_quests() -> String:
	if quests.size() == 0:
		return "Você não tem nenhuma missão no momento."
	
	var quests_description = ""
	
	for i in quests:
		if quests_description != "":
			quests_description += ", "	
		quests_description += i.quest_name + " "	
		
	return "Suas missões são: " + quests_description
