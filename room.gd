@tool

extends PanelContainer
class_name Room

@export var room_name := "Room Name" : set = set_room_name
@export_multiline var room_description := "This is the description" : set = set_room_description

var exits : Dictionary = {}
var items : Array = []

func set_room_name(new_name : String):
	$MarginContainer/Rows/RoomName.text = new_name
	room_name = new_name

func set_room_description(new_description : String):
	$MarginContainer/Rows/RoomDescription.text = new_description
	room_description = new_description
	
func add_item(item: Item):
	items.append(item)
	
func get_full_description() -> String:
	var descriptions = PackedStringArray([
		get_room_description(),
		get_items(),
		get_exits()
	])
	
	var full_description = "\n".join(descriptions)
	
	return full_description
	
func get_room_description() -> String:
	return "You are now in " + room_name + ". " + room_description	

func get_items() -> String:
	if items.size() == 0:
		return "No items to pickup"
	
	var all_items = ""
	
	for i in items:
		all_items += i.item_name + " "	
		
	return "Items: " + all_items

func get_exits() -> String:
	return "Exits: " + " ".join(PackedStringArray(exits.keys()))
	
func connect_exit(direction : String, room):
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exits[direction] = exit
	
	match direction:
		"west":
			room.exits["east"] = exit
		"east":
			room.exits["west"] = exit
		"south":
			room.exits["north"] = exit
		"north":
			room.exits["south"] = exit
