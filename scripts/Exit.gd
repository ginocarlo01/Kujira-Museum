extends Resource;
class_name Exit

var room_1 = null
var room_1_is_locked := false

var room_2 = null
var room_2_is_locked := false

func get_other_room(current_room):
	var other_room = null
	if current_room == room_1:
		other_room = room_2
	elif current_room == room_2:
		other_room = room_1
	else:
		printerr("The room you've sent is not valid!") 
	return other_room
