extends Node

func _ready() -> void:
	# KEYS :
	#var key = Item.new()
	#key.initialize("Blue_Key", Types.ItemTypes.KEY)
	var key = load_item("key")
	key.set_use_value($OutsideRoom, "You can use it to go outside")
	
	var guard_sword = load_item("guard_sword")
	guard_sword.set_use_value($OutsideRoom, "You can use it to go outside")
	
	# NPCs:
	var innkeeper = load_npc("Innkeeper")
	var guard = load_npc("Guard")
	
	# Garden :
	$Garden.add_item(guard_sword)
	 
	# HOUSE :
	$House.connect_exit("east", $OutsideRoom) 
	$House.connect_exit("path", $EndPath) 
	$House.connect_exit("garden", $Garden,"gate") 
	
	# OUTSIDE:
	#$OutsideRoom.add_item(key)
	$OutsideRoom.add_npc(guard)
	$OutsideRoom.connect_exit("north", $ShedRoom)
	$OutsideRoom.lock_exit("north", $OutsideRoom)
	$OutsideRoom.connect_exit("east", $Forest)
	
	# FOREST:
	$Forest.connect_exit("south", $EndPath)
	$Forest.lock_exit("south", $Forest)
	$Forest.connect_exit("inside", $SmallHouse)
	
	# SMALL HOUSE:
	$SmallHouse.add_npc(innkeeper)
	
func load_item(item_name : String):
	return load("res://Items/" + item_name + ".tres") 
	
func load_npc(npc_name : String):
	return load("res://NPCs/" + npc_name + ".tres") 
	
