@tool

extends PanelContainer
class_name Room

@export var room_name := "Room Name" : set = set_room_name
@export_multiline var room_description := "This is the description" : set = set_room_description

var exits : Dictionary = {}
var npcs : Array = []
var items : Array = []

func set_room_name(new_name : String):
	$MarginContainer/Rows/RoomName.text = new_name
	room_name = new_name

func set_room_description(new_description : String):
	$MarginContainer/Rows/RoomDescription.text = new_description
	room_description = new_description
	
func add_item(item: Item):
	items.append(item)
	
func remove_item(item: Item):
	items.erase(item)
	
func add_npc(npc: NPC):
	npcs.append(npc)
	
func remove_npc(npc: NPC):
	npcs.erase(npc)
	
func get_full_description() -> String:
	var full_description = PackedStringArray([get_room_description()])
	# NPCs :
	var npcs_description = get_npcs_description()
	if npcs_description != "":
		full_description.append(npcs_description)
	# Items :	
	var items_description = get_items_description()
	if items_description != "":
		full_description.append(items_description)
	# Items :
	var exits_description = get_exits_description()
	if exits_description != "":
		full_description.append(exits_description)
		
	var full_description_string = "\n".join(full_description)
	
	return full_description_string
	
func get_room_description() -> String:
	return "You are now in " + room_name + ". " + room_description	

func get_items_description() -> String:
	if items.size() == 0:
		return ""
	
	var all_items = ""
	
	for i in items:
		if all_items != "":
			all_items += ", "	
		all_items += i.item_name
		
	return "Items: " + all_items
	
func get_npcs_description() -> String:
	if npcs.size() == 0:
		return ""
	
	var all_npcs = ""
	
	for i in npcs:
		if all_npcs != "":
			all_npcs += ", "	
		all_npcs += i.npc_name
		
	return "NPCs: " + all_npcs

func get_exits_description() -> String:
	if exits.keys().size() == 0:
		return ""
		
	return "Exits: " + " ".join(PackedStringArray(exits.keys()))
	
func lock_exit(direction : String, room):
	exits[direction].lock_exit_of_room(room)
	
func unlock_exit(direction : String, room):
	exits[direction].unlock_exit_of_room(room)
	
func check_exit_locked(direction : String) -> bool:
	return exits[direction].is_room_locked(self)
	
func connect_exit(direction : String, room, override_room_2 = "null"):
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exits[direction] = exit
	
	#With override, you don't have to add into the possible item list
	if override_room_2 != "null":
		room.exits[override_room_2] = exit
	else:
		match direction:
			"west":
				room.exits["east"] = exit
			"east":
				room.exits["west"] = exit
			"south":
				room.exits["north"] = exit
			"north":
				room.exits["south"] = exit
			"path":
				room.exits["path"] = exit
			"inside":
				room.exits["outside"] = exit
			"outside":
				room.exits["inside"] = exit
