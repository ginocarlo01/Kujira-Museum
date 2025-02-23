extends Node
class_name Player

var inventory : Array = []
var quests : Array = []

func take_item(item : Item, mute = false) -> String:
	if !mute:
		SoundManager.play_sfx(SoundManager.SFXSounds.get_item)
	inventory.append(item)
	return "Você recebeu " + Types.wrap_item_text(item.item_name) 
	
func drop_item(item : Item) -> String:
	SoundManager.play_sfx(SoundManager.SFXSounds.drop_item)
	inventory.erase(item)
	return "Você dropou " + Types.wrap_item_text(item.item_name)
	
func give_item(item : Item) -> String:
	SoundManager.play_sfx(SoundManager.SFXSounds.give_item)
	inventory.erase(item)
	return "Você deu " + Types.wrap_item_text(item.item_name)
	
func add_quest(quest : Quest) -> String:
	SoundManager.play_sfx(SoundManager.SFXSounds.got_quest)
	quests.append(quest)
	return "A missão " + Types.wrap_quest_text(quest.quest_name) + " foi adicionada."
	
func remove_quest(quest : Quest):
	SoundManager.play_sfx(SoundManager.SFXSounds.got_quest)
	quests.erase(quest)
	return "A missão " + Types.wrap_quest_text(quest.quest_name) + " foi completada."
	
func has_quest(quest : Quest):
	for q in quests:
		if q == quest:
			return true
			
	return false
	
func has_item_on_inventory(item : String, specific_name = false) -> Item:
	var item_first_name = ""
	for i in inventory:
		if !specific_name:
			var item_names = i.item_name.split(" ", false)
			if item_names.size() > 1:
				item_first_name = item_names[0].to_lower()
			else:
				item_first_name = i.item_name.to_lower()
		else:
			item_first_name = i.item_name
			
		if item == item_first_name:
			return i
	
	return null
	
func get_inventory() -> String:
	SoundManager.play_sfx(SoundManager.SFXSounds.get_item)
	
	if inventory.size() == 0:
		return "Seu inventário está vazio."
	
	var inventory_description = ""
	
	for i in inventory:
		if inventory_description != "":
			inventory_description += "\n > "	
		inventory_description += Types.wrap_item_text(i.item_name)
		
	return "Os itens que você tem são: \n > " + inventory_description
	
func get_quests() -> String:
	SoundManager.play_sfx(SoundManager.SFXSounds.got_quest)
	if quests.size() == 0:
		return "Você não tem nenhuma missão no momento."
	
	var quests_description = ""
	
	for i in quests:
		if quests_description != "":
			quests_description += "\n > "	
		quests_description += Types.wrap_quest_text(i.quest_name) + ": " + i.quest_description	
		
	return "Suas missões são: \n > " + quests_description
