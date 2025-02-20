extends Node
class_name Player

var inventory : Array = []

func take_item(item : Item):
	inventory.append(item)
	
func drop_item(item : Item):
	inventory.erase(item)
	
func get_inventory() -> String:
	if inventory.size() == 0:
		return "Your inventory is empty."
	
	var inventory_description = ""
	
	for i in inventory:
		if inventory_description != "":
			inventory_description += ", "	
		inventory_description += i.item_name + " "	
		
	return "You have: " + inventory_description
