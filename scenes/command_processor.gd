extends Node

var current_room : Room = null

func initialize(starting_room) -> String:
	return change_room(starting_room)

func process_command(input : String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return "No words found!"
		
	var first_word = words[0].to_lower()
	var second_word = ""
	
	if words.size() > 1:
		second_word = words[1]
		
	match first_word:
		"go":
			return go(second_word).to_lower()
		"help":
			return help()
		_:
			return "Unrecognized command, please try again !"
			
func go(second_word : String) -> String:
	if second_word == "":
		return "Go where?"
	
	if current_room.exits.keys().has(second_word):
		#var change_response = change_room(current_room.exits[second_word])
		var change_response = change_room(current_room.exits[second_word].get_other_room(current_room))
		return "\n".join(PackedStringArray(["You go %s" %second_word, change_response]))
	else:	
		return "This is not a valid exit."
	
func help() -> String:
	return "You can use these commands: go [location], help"
	
func change_room(new_room : Room) -> String:
	current_room = new_room

	return new_room.get_full_description()
	
		
	
