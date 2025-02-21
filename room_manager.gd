extends Node
class_name RoomManager

func _ready() -> void:
	# KEYS :
	#var key = Item.new()
	#key.initialize("Blue_Key", Types.ItemTypes.KEY)
	#var key = load_item("key")
	#key.set_use_value($OutsideRoom, "You can use it to go outside")
	
	var translator_arti = load_item("translator_arti")
	
	# NPCs:
	var innkeeper = load_npc("Innkeeper")
	var cientista = load_npc("Cientista")
	
	# Palco Inicial:
	$PalcoInicial.connect_exit("oeste",$SalaCientista)
	
	# SalaCientista :
	$SalaCientista.add_npc(cientista)
	
	# ArmazemCientista :
	$ArmazemCientista.add_item(translator_arti)
	 #
	## HOUSE :
	#$House.connect_exit("east", $OutsideRoom) 
	#$House.connect_exit("path", $EndPath) 
	#$House.connect_exit("garden", $Garden,"gate") 
	#
	## OUTSIDE:
	##$OutsideRoom.add_item(key)
	#$OutsideRoom.add_npc(guard)
	#$OutsideRoom.connect_exit("north", $ShedRoom)
	#$OutsideRoom.lock_exit("north", $OutsideRoom)
	#$OutsideRoom.connect_exit("east", $Forest)
	#
	## FOREST:
	#$Forest.connect_exit("south", $EndPath)
	#$Forest.lock_exit("south", $Forest)
	#$Forest.connect_exit("inside", $SmallHouse)
	#
	## SMALL HOUSE:
	#$SmallHouse.add_npc(innkeeper)
	
func connect_exit(room_1 : String, direction : String, room_2 : String):
	var node_1 = get_node(room_1)
	var node_2 = get_node(room_2)
	node_1.connect_exit(direction,node_2)
	
func load_item(item_name : String):
	return load("res://Items/" + item_name + ".tres") 
	
func load_npc(npc_name : String):
	return load("res://NPCs/" + npc_name + ".tres") 
	
