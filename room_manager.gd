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
	$Pocilga.connect_exit("norte", $Estabulo, "null", true)
	
	# Estábulo:
	$Estabulo.connect_exit("norte", $ArmazemCavalo)
	$Estabulo.lock_exit("norte", $Estabulo)
	var kai = load_npc("Kai")
	var epona = load_npc("Epona")
	$Estabulo.add_npc(kai)
	$Estabulo.add_npc(epona)
	
	# ArmazemCavalo:
	var translator_peri = load_item("translator_peri")
	$ArmazemCavalo.add_item(translator_peri)
	
	#ExposicaoMar1
	var baleia_jubarte = load_npc("Baleia")
	var hipopotamo = load_npc("Hipopotamo")
	$ExposicaoMar1.add_npc(baleia_jubarte)
	$ExposicaoMar1.add_npc(hipopotamo)
	$ExposicaoMar1.connect_exit("leste", $ExposicaoMar2)
	$ExposicaoMar1.connect_exit("norte", $ExposicaoMar3)
	
	#ExposicaoMar2
	var foquinha = load_npc("Foquinha")
	var andrew = load_npc("Andrew")
	$ExposicaoMar2.add_npc(foquinha)
	$ExposicaoMar2.add_npc(foquinha)
	
	#ExposicaoMar3
	
	$ExposicaoMar3.connect_exit("leste", $SalaDocumentos)
	
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
	
