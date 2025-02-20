extends Node

var current_room : Room = null
var player : Player = null

func initialize(starting_room, player) -> String:
	self.player = player
	return change_room(starting_room)

func process_command(input : String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return "No words found!"
		
	var first_word = words[0].to_lower()
	var second_word = ""
	var third_word = ""
	
	if words.size() > 1:
		second_word = words[1]
		
	if words.size() > 2:
		third_word = words[2]
		
	match first_word:
		"go":
			return go(second_word)
		"take":
			return take(second_word)
		"drop":
			return drop(second_word)
		"use":
			return use(second_word, third_word)
		"give":
			return give(second_word, third_word)
		"talk":
			return talk(second_word)
		"help":
			return help()
		"inventory":
			return inventory()
		_:
			return Types.wrap_system_text("Unrecognized command, please try again !")
			
func go(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Go where?")
	
	if current_room.exits.keys().has(second_word):
		#var change_response = change_room(current_room.exits[second_word])
		if !current_room.check_exit_locked(second_word):
			var change_response = change_room(current_room.exits[second_word].get_other_room(current_room))
			return "\n".join(PackedStringArray(["You go " + Types.wrap_location_text(second_word), change_response]))
		else:
			return "The way " + Types.wrap_location_text(second_word) + " is currently " + Types.wrap_system_text("locked!")
	else:	
		return Types.wrap_system_text("This is not a valid direction.")

func take(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Take what?")
		
	for i in current_room.items:
		if second_word.to_lower() == i.item_name.to_lower():
			current_room.remove_item(i)
			player.take_item(i)
			return "You take " + Types.wrap_item_text(i.item_name)
		
	return Types.wrap_system_text("There is no item with this name in this room.")
	
func drop(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Drop what?")
		
	for i in player.inventory:
		if second_word.to_lower() == i.item_name.to_lower():
			current_room.add_item(i)
			player.drop_item(i)
			return "You drop " + Types.wrap_item_text(i.item_name)
		
	return Types.wrap_system_text("There is no item with this name in your inventory.")
	
func use(second_word : String, third_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Use what?")
		
	if third_word == "":
		return Types.wrap_system_text("In which exit?")
		
	for i in player.inventory:
		if second_word.to_lower() == i.item_name.to_lower():
			match i.item_type:
				Types.ItemTypes.KEY:
					if current_room.exits.keys().has(third_word):
						var current_exit = current_room.exits[third_word] 
						current_exit.unlock_exit_of_room(current_room)
						player.drop_item(i)
						return "You unlocked the " + Types.wrap_location_text(third_word) + " direction!"
					else:
						return Types.wrap_system_text("This is not a valid direction")
				_:
					return Types.wrap_system_text("This is not a valid item")
				
	return Types.wrap_system_text("This is not a valid item from your inventory.")
	
func give(second_word : String, third_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Give what?")
		
	if third_word == "":
		return Types.wrap_system_text("To whom?")
		
	for i in player.inventory:
		if second_word.to_lower() == i.item_name.to_lower():
			for npc in current_room.npcs:
				if third_word.to_lower() == npc.npc_name.to_lower():
					if npc.quest_item.item_name.to_lower() == i.item_name.to_lower():
						npc.receive_quest_item()
						player.drop_item(i)
						var reward : Item = npc.give_reward_to_player()
						player.take_item(reward)
						return "You give " + Types.wrap_item_text(second_word) + " to " + Types.wrap_npc_text(third_word) + " and have received " + Types.wrap_item_text(reward.item_name) + " as a reward!"
					else:
						return Types.wrap_system_text("This person doesn't need this item")
						
			return Types.wrap_system_text("There no person with this name in this room")
				
	return Types.wrap_system_text("This is not a valid item from your inventory.")
	
func talk(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Talk to whom?")
		
	for npc in current_room.npcs:
		if second_word.to_lower() == npc.npc_name.to_lower():
			return Types.wrap_npc_text(npc.npc_name) + ": \"" + npc.get_dialog() + "\""
		
	return Types.wrap_system_text("That person is not in this room.")
	
func inventory() -> String:
	return player.get_inventory()
	
func help() -> String:
	return "\n".join(PackedStringArray([
		"You can use these commands: ",
		" go " + Types.wrap_location_text("[location]") + ",",
		" take " + Types.wrap_item_text("[item]") + ",",
		" drop " + Types.wrap_item_text("[item]") + ",",
		" use " + Types.wrap_item_text("[item]") + Types.wrap_location_text(" [direction],"),
		" talk " + Types.wrap_npc_text("[npc]") + ",",
		" give " + Types.wrap_item_text("[item]") + " " + Types.wrap_npc_text("[npc]") + ",",
		" inventory,",
		" help"
	]))

func change_room(new_room : Room) -> String:
	current_room = new_room

	return new_room.get_full_description()
	
		
	
