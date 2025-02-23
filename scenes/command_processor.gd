extends Node

var current_room : Room = null
var player : Player = null
var room_manager : RoomManager = null

@onready var sfx_player = $"../SFXPlayer"

@export var sfx_enter_room : AudioStream
@export var sfx_unlocked : AudioStream
@export var sfx_drop_item : AudioStream
@export var sfx_get_item : AudioStream
@export var sfx_got_quest : AudioStream
@export var sfx_player_gave_item : AudioStream

func initialize(starting_room, player, room_manager : RoomManager) -> String:
	self.player = player
	self.room_manager = room_manager
	return change_room(starting_room)

func process_command(input : String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return "No words found!"
		
	var first_word = words[0].to_lower()
	var second_word = ""
	var third_word = ""
	
	if words.size() > 1:
		second_word = words[1]
		
	if words.size() > 2:
		third_word = words[2]
		
	match first_word:
		"ir":
			return go(second_word)
		"pegar":
			return take(second_word)
		"dropar":
			return drop(second_word)
		"usar":
			return use(second_word, third_word)
		"dar":
			return give(second_word, third_word)
		"falar":
			return talk(second_word)
		"inventário":
			return inventory()
		"missões":
			return quests()	
		"saídas":
			return exits()	
		"descrever":
			return describe_item(second_word)
		"ajuda":
			return help()
		"sonhar":
			get_tree().quit()
			return "adeus"
		_:
			return Types.wrap_system_text("Comando não identificado ! Tente novamente ou digite ajuda")
			
func go(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Go where?")
	
	if current_room.exits.keys().has(second_word):
		#var change_response = change_room(current_room.exits[second_word])
		if !current_room.check_exit_locked(second_word):
			var change_response = change_room(current_room.exits[second_word].get_other_room(current_room))
			return "\n".join(PackedStringArray(["Você foi para " + Types.wrap_location_text(second_word), change_response]))
		else:
			return "A saída para " + Types.wrap_location_text(second_word) + " está " + Types.wrap_system_text("bloqueada!")
	else:	
		return Types.wrap_system_text("Essa não é uma direção válida...")

func take(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Pegar o que?")
		
	var item_wanted : Item
	
	item_wanted = current_room.has_item_on_room(second_word.to_lower())
	
	if item_wanted != null:
		current_room.remove_item(item_wanted)
		player.take_item(item_wanted)
		sfx_player.stream = sfx_get_item
		sfx_player.play()
		return "Você pegou " + Types.wrap_item_text(item_wanted.item_name)
		
	return Types.wrap_system_text("Aqui não tem nenhum item com esse nome...")
	
func describe_item(second_word : String) -> String:	
	if second_word == "":
		return Types.wrap_system_text("Descrever o que?")
		
	var item_wanted : Item
	
	item_wanted = current_room.has_item_on_room(second_word.to_lower())
	
	if item_wanted == null:	
		item_wanted = player.has_item_on_inventory(second_word.to_lower())
				
	if item_wanted != null:
		return "Sobre " + Types.wrap_item_text(item_wanted.item_name) + ": " + item_wanted.use_value_description
	else:	
		return Types.wrap_system_text("Aqui não tem nenhum item com esse nome...")
	
	
func drop(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Drop what?")
		
	var item_wanted : Item
	
	item_wanted = player.has_item_on_inventory(second_word.to_lower())
	
	if item_wanted != null:
		current_room.add_item(item_wanted)
		player.drop_item(item_wanted)
		sfx_player.stream = sfx_drop_item
		sfx_player.play()
		return "Você dropou " + Types.wrap_item_text(item_wanted.item_name)
	else:
		return Types.wrap_system_text("Você não tem esse item no seu inventário.")
	
func use(second_word : String, third_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Usar o que?")
		
	if third_word == "":
		return Types.wrap_system_text("Em qual saída?")
		
	var item_wanted : Item
	
	item_wanted = player.has_item_on_inventory(second_word.to_lower())
	
	if item_wanted != null:
		match item_wanted.item_type:
			Types.ItemTypes.KEY:
				if current_room.exits.keys().has(third_word):
					var current_exit = current_room.exits[third_word] 
					current_exit.unlock_exit_of_room(current_room)
					player.drop_item(item_wanted)
					sfx_player.stream = sfx_unlocked
					sfx_player.play()
					return "Você desbloqueou a passagem " + Types.wrap_location_text(third_word) 
				else:
					return Types.wrap_system_text("Essa não é uma direção válida")
			_:
				return Types.wrap_system_text("Esse não é um item válido")
			
	return Types.wrap_system_text("Você não tem esse item no seu inventário.")
	
func give(second_word : String, third_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Dar o que?")
		
	if third_word == "":
		return Types.wrap_system_text("Para quem?")
		
	var item_wanted : Item
	
	item_wanted = player.has_item_on_inventory(second_word.to_lower())
	
	if item_wanted != null:
		var npc_wanted : NPC
		npc_wanted = current_room.is_npc_on_room(third_word.to_lower())
		if npc_wanted != null:
			if npc_wanted.quest_item.item_name.to_lower() == item_wanted.item_name.to_lower():
				npc_wanted.receive_quest_item()
				player.drop_item(item_wanted)
				var reward : Item
				if npc_wanted.reward_item != null:
					reward = npc_wanted.give_reward_to_player()
					player.take_item(reward)
					sfx_player.stream = sfx_player_gave_item
					sfx_player.play()
					return "Você deu " + Types.wrap_item_text(second_word) + " para " + Types.wrap_npc_text(third_word) + " e recebeu " + Types.wrap_item_text(reward.item_name) + " como recompensa!"
				else:
					sfx_player.stream = sfx_player_gave_item
					sfx_player.play()
					return "Você deu " + Types.wrap_item_text(second_word) + " para " + Types.wrap_npc_text(third_word) 
			else:
				return Types.wrap_system_text("This person doesn't need this item")
				
		return Types.wrap_system_text("There no person with this name in this room")
			
	return Types.wrap_system_text("This is not a valid item from your inventory.")
	
func talk(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("Talk to whom?")
		
	var npc_wanted : NPC
	
	npc_wanted = current_room.is_npc_on_room(second_word.to_lower())
		
	if npc_wanted != null:
		var npc_type : Types.NPCTypes = npc_wanted.get_type()
		match npc_type:
			Types.NPCTypes.SCIENTIST:
				var quest = load("res://Quests/SalvarRoger.tres")
				room_manager.connect_exit("SalaCientista", "oeste", "ArmazemCientista")
				room_manager.connect_exit("SalaCientista", "norte", "Pocilga")
				current_room.remove_npc(npc_wanted)
				return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\" \n" + player.add_quest(quest) + "\n" + current_room.get_exits_description()
			
			Types.NPCTypes.ARTIO:
				var item_wanted : Item
				item_wanted = player.has_item_on_inventory("tradutor")
			
				# DIALOGUE IF THE PLAYER HAS THE TRANSLATOR	
				if item_wanted != null:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\""
			
			Types.NPCTypes.ARTIO_GIRAFFE:
				var item_wanted : Item
				item_wanted = player.has_item_on_inventory("tradutor")
			
				# DIALOGUE IF THE PLAYER HAS THE TRANSLATOR	
				if item_wanted != null:
					if !npc_wanted.has_given_reward:
						room_manager.add_item(current_room, "ChaveCavalista")
						sfx_player.stream = sfx_get_item
						sfx_player.play()
						npc_wanted.has_given_reward = true
						return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\"" + "\n" + current_room.get_items_description()
					else:
						return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\"" + "\n" + current_room.get_items_description()
					
			Types.NPCTypes.PERISSO:
				var item_wanted : Item
				item_wanted = player.has_item_on_inventory("Tradutor Perissodáctilo", true)
			
				# DIALOGUE IF THE PLAYER HAS THE TRANSLATOR	
				if item_wanted != null:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\""
					
			Types.NPCTypes.PERISSO_EPONA:
				var item_wanted : Item
				item_wanted = player.has_item_on_inventory("Tradutor Perissodáctilo", true)
			
				# DIALOGUE IF THE PLAYER HAS THE TRANSLATOR	
				if item_wanted != null:
					room_manager.connect_exit("Estabulo", "leste", "ExposicaoMar1")
					current_room.remove_npc(npc_wanted)
					sfx_player.stream = sfx_unlocked
					sfx_player.play()
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\"" + "\n" + current_room.get_exits_description()
			
			Types.NPCTypes.ARMALDO:
				var player_has_item = player.has_item_on_inventory("Love Spell da Victoria's Secret", true)
				
				if !player_has_item:
					sfx_player.stream = sfx_get_item
					sfx_player.play()
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + npc_wanted.get_extra_dialog() + "\"" + "\n" + player.take_item(npc_wanted.give_reward_to_player())
	
			Types.NPCTypes.LOVE_SEASHELL:
				var player_has_item = player.has_item_on_inventory("Conchinha")
				
				if player_has_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + npc_wanted.get_extra_dialog() + "\""
							
			Types.NPCTypes.LOVE_ARMALDO:
				var player_has_item = player.has_item_on_inventory("Love Spell da Victoria's Secret", true)
				
				if player_has_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + npc_wanted.get_extra_dialog() + "\""
							
			
			Types.NPCTypes.SEAL_PUP:
				var quest : Quest = load("res://Quests/AjudarFoquinha.tres")
				var player_has_quest = player.has_quest(quest)
				
				if !player_has_quest and !npc_wanted.has_received_quest_item:
					sfx_player.stream = sfx_got_quest
					sfx_player.play()
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + player.add_quest(quest)
				elif player_has_quest and !npc_wanted.has_received_quest_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
				elif player_has_quest and npc_wanted.has_received_quest_item:
					current_room.connect_exit("praia", $"../RoomManager/Praia", "oeste", false)
					#room_manager.connect_exit("ExposicaoMar2", "praia", "Praia")
					sfx_player.stream = sfx_unlocked
					sfx_player.play()
					return player.remove_quest(quest) + "\n" +Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + current_room.get_exits_description()	
				elif !player_has_quest and npc_wanted.has_received_quest_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + current_room.get_exits_description()	
			
			Types.NPCTypes.SEAL_MOM:
				var quest : Quest = load("res://Quests/AjudarFoquinha.tres")
				var player_has_quest = player.has_quest(quest)
				var item_wanted = player.has_item_on_inventory(npc_wanted.reward_item.item_name, true)
				var npc_given_item = npc_wanted.has_given_reward
				
				if !player_has_quest and item_wanted == null:
					sfx_player.stream = sfx_got_quest
					sfx_player.play()
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + player.add_quest(quest) + "\n" + player.take_item(npc_wanted.give_reward_to_player())
				elif player_has_quest and item_wanted == null and !npc_given_item:
					sfx_player.stream = sfx_get_item
					sfx_player.play()
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_extra_dialog() + npc_wanted.get_dialog() + "\"" + "\n" + player.take_item(npc_wanted.give_reward_to_player())
				elif player_has_quest and item_wanted != null and npc_given_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_extra_dialog() + npc_wanted.get_dialog() + "\""
				elif !player_has_quest and item_wanted == null and npc_given_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_post_dialog()
			Types.NPCTypes.ROGER:
				if !npc_wanted.has_talked_to_npc:
					var quest : Quest = load("res://Quests/SalvarRoger.tres")
					
					return player.remove_quest(quest) + "\n"+ Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
			_:
				pass
		return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
	
	return Types.wrap_system_text("Essa pessoa não está aqui!")
	
func inventory() -> String:
	sfx_player.stream = sfx_get_item
	sfx_player.play()
	return player.get_inventory()
	
func quests() -> String:
	sfx_player.stream = sfx_got_quest
	sfx_player.play()
	return player.get_quests()
	
func exits() -> String:
	return current_room.get_exits_description()
	
func help() -> String:
	return "\n".join(PackedStringArray([
		"Você pode usar os comando abaixo: ",
		" ir " + Types.wrap_location_text("[direção ou local]") + ",",
		" pegar " + Types.wrap_item_text("[item(primeiro nome)]") + ",",
		" dropar " + Types.wrap_item_text("[item]") + ",",
		" usar " + Types.wrap_item_text("[item]") + Types.wrap_location_text(" [direção],"),
		" falar " + Types.wrap_npc_text("[entidade(primeiro nome)]") + ",",
		" dar " + Types.wrap_item_text("[item]") + " " + Types.wrap_npc_text("[npc]") + ",",
		" inventário,",
		" missões,",
		" saídas,",
		" descrever "+ Types.wrap_item_text("[primeiro nome do item]" + ","),
		" ajuda"
	]))
	


func change_room(new_room : Room) -> String:
	if current_room != null:
		if current_room.audio != new_room.audio and new_room.audio != null:
			new_room.play_audio()
	else:
		new_room.play_audio()
		
	current_room = new_room
	sfx_player.stream = sfx_enter_room
	sfx_player.play()
	 
	return new_room.get_full_description()
	
		
	
