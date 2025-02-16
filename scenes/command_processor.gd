extends Node

signal response_generated(response_text)

var current_room = null

func initialize(starting_room):
	current_room = starting_room

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
	
	return "You go %s" %second_word
	
func help() -> String:
	return "You can use these commands: go [location], help"
	
func change_room(new_room : Room):
	response_generated.emit("You go to " + new_room.room_description)
	response_generated.emit(new_room.room_description)
	
		
	
