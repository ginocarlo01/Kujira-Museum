extends Node
class_name RoomManager

func _ready() -> void:

	# Palco Inicial:
	$"Palco inicial".connect_exit("oeste",$"Sala do Cientista")
	
	# SalaCientista :
	var cientista = load_npc("Cientista")
	$"Sala do Cientista".add_npc(cientista)
	
	# ArmazemCientista :
	var translator_arti = load_item("translator_arti")
	$"Armazém do Cientista".add_item(translator_arti)
	 
	# Pocilga :
	var porcao = load_npc("Porcao")
	var porquinho = load_npc("Porquinho")
	var girafona = load_npc("Girafona")
	$Pocilga.add_npc(porcao)
	$Pocilga.add_npc(porquinho)
	$Pocilga.add_npc(girafona)
	$Pocilga.connect_exit("norte", $Estábulo, "null", true)
	
	# Estábulo:
	$Estábulo.connect_exit("norte", $"Armazém dos cavalos")
	$Estábulo.lock_exit("norte", $Estábulo)
	var kai = load_npc("Kai")
	var epona = load_npc("Epona")
	$Estábulo.add_npc(kai)
	$Estábulo.add_npc(epona)
	
	# ArmazemCavalo:
	var translator_peri = load_item("translator_peri")
	$"Armazém dos cavalos".add_item(translator_peri)
	
	#ExposicaoMar1
	var baleia_jubarte = load_npc("Baleia")
	var hipopotamo = load_npc("Hipopotamo")
	$"Exposição Marinha 1".add_npc(baleia_jubarte)
	$"Exposição Marinha 1".add_npc(hipopotamo)
	$"Exposição Marinha 1".connect_exit("leste", $"Exposição Marinha 2")
	$"Exposição Marinha 1".connect_exit("norte", $"Exposição Marinha 3")
	
	#ExposicaoMar2
	var foquinha = load_npc("Foquinha")
	var andrew = load_npc("Andrew")
	$"Exposição Marinha 2".add_npc(foquinha)
	$"Exposição Marinha 2".add_npc(andrew)
	
	#ExposicaoMar3
	var focamom = load_npc("Focamom")
	var indohyus = load_npc("Indohyus")
	$"Exposição Marinha 3".add_npc(focamom)
	$"Exposição Marinha 3".add_npc(indohyus)
	$"Exposição Marinha 3".connect_exit("leste", $"Sala dos documentos")
	$"Exposição Marinha 3".connect_exit("norte", $"Sala dos curiosos")
	$"Exposição Marinha 3".lock_exit("norte", $"Exposição Marinha 3")
	
	#SalaDocumentos
	var documento = load_item("Documento")
	$"Sala dos documentos".add_item(documento)
	
	#SalaCuriosos
	var armaldo = load_npc("Armaldo")
	$"Sala dos curiosos".add_npc(armaldo)
	
	#Praia
	$Praia.connect_exit("norte", $"Casa da praia")
	$Praia.connect_exit("sul", $"Fogueira da praia")
	
	#CasaPraia
	var casca_de_molusco = load_item("Casca_de_molusco")
	var espada = load_item("Espada")
	var conchinha = load_item("Conchinha")
	var madreperola = load_item("Madreperola")
	$"Casa da praia".add_item(casca_de_molusco)
	$"Casa da praia".add_item(espada)
	$"Casa da praia".add_item(conchinha)
	$"Casa da praia".add_item(madreperola)
	
	#FogueiraPraia
	var guerreiro = load_npc("Guerreiro")
	$"Fogueira da praia".add_npc(guerreiro)
	$"Fogueira da praia".connect_exit("barco", $"Ilha de Flores", "fogueira")
	$"Fogueira da praia".lock_exit("barco", $"Fogueira da praia")
	
	#IlhaFlores
	var florensi = load_npc("Florensi")
	$"Ilha de Flores".add_npc(florensi)
	$"Ilha de Flores".connect_exit("leste", $"Ilha Marôn")
	
	#IlhaMaron
	var fredo = load_npc("Fredo")
	$"Ilha Marôn".add_npc(fredo)
	$"Ilha Marôn".connect_exit("sul", $"Sala Final")
	$"Ilha Marôn".lock_exit("sul", $"Ilha Marôn")
	$"Ilha Marôn".connect_exit("leste", $"Ilha Bugada")
	
	#IlhaBugada
	var chaveJubarte = load_item("ChaveJubarte")
	$"Ilha Bugada".add_item(chaveJubarte)
	
	#SalaFinal
	var roger = load_npc("Roger")
	$"Sala Final".add_npc(roger)
	var gnomo = load_npc("Gnomo")
	$"Sala Final".add_npc(gnomo)
	
func connect_exit(room_1 : String, direction : String, room_2 : String, direction_back_override : String = "null") -> String:
	var node_1 = get_node(room_1)
	var node_2 = get_node(room_2)
	node_1.connect_exit(direction,node_2, direction_back_override)
	return Types.wrap_system_text("Nova direção encontrada: ") + Types.wrap_location_text(direction)
	
func add_item(room:Room, item_name : String):
	room.add_item(load_item(item_name))
	
func load_item(item_name : String):
	return load("res://Items/" + item_name + ".tres") 
	
func load_npc(npc_name : String):
	return load("res://NPCs/" + npc_name + ".tres") 
	
