extends Node
class_name RoomManager

func _ready() -> void:
	# KEYS :
	#var key = Item.new()
	#key.initialize("Blue_Key", Types.ItemTypes.KEY)
	#var key = load_item("key")
	#key.set_use_value($OutsideRoom, "You can use it to go outside")
	
	
	
	# Palco Inicial:
	$PalcoInicial.connect_exit("oeste",$SalaCientista)
	
	# SalaCientista :
	var cientista = load_npc("Cientista")
	$SalaCientista.add_npc(cientista)
	
	# ArmazemCientista :
	var translator_arti = load_item("translator_arti")
	$ArmazemCientista.add_item(translator_arti)
	 
	# Pocilga :
	var porcao = load_npc("Porcao")
	var porquinho = load_npc("Porquinho")
	var girafona = load_npc("Girafona")
	$Pocilga.add_npc(porcao)
	$Pocilga.add_npc(porquinho)
	$Pocilga.add_npc(girafona)
	
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
	
func add_item(room:Room, item_name : String):
	room.add_item(load_item(item_name))
	
func load_item(item_name : String):
	return load("res://Items/" + item_name + ".tres") 
	
func load_npc(npc_name : String):
	return load("res://NPCs/" + npc_name + ".tres") 
	
