extends Node

var current_room : Room = null
var player : Player = null
var room_manager : RoomManager = null

var current_speed : Types.SpeedTypes = Types.SpeedTypes.NORMAL
signal speed_changed(value : Types.SpeedTypes)

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
			return describe_item(second_word, third_word)
		"velocidade":
			return change_speed(second_word)
		"ajuda":
			return help()
		"sonhar":
			get_tree().quit()
			return "_"
		_:
			return Types.wrap_system_text("Comando não identificado ! Tente novamente ou digite ajuda")
			
func go(second_word : String) -> String:
	if second_word == "":
		change_speed_by_enum(Types.SpeedTypes.NONE)
		return Types.wrap_system_text("Ir aonde?")
	
	if current_room.exits.keys().has(second_word):
		if !current_room.check_exit_locked(second_word):
			change_speed_by_enum(current_speed)
			var change_response = change_room(current_room.exits[second_word].get_other_room(current_room))
			return "\n".join(PackedStringArray(["Você foi para " + Types.wrap_location_text(second_word), change_response]))
		else:
			change_speed_by_enum(Types.SpeedTypes.NONE)
			return "A saída para " + Types.wrap_location_text(second_word) + " está " + Types.wrap_system_text("bloqueada!")
	else:	
		change_speed_by_enum(Types.SpeedTypes.NONE)
		return Types.wrap_system_text("Essa não é uma direção válida...")

func change_speed(second_word : String) -> String:
	if second_word == "":
		return Types.wrap_system_text("lenta, normal ou rápida?")
	
	var speed_type : Types.SpeedTypes
	
	if second_word in ["lenta", "normal", "rápida", "nula"]:
		match second_word:
			"lenta":
				speed_type = Types.SpeedTypes.SLOW   # Lento
			"normal":
				speed_type = Types.SpeedTypes.NORMAL   # Normal
			"rápida":
				speed_type = Types.SpeedTypes.FAST   # Rápido
			"nula":
				speed_type = Types.SpeedTypes.NONE   # Rápido
			_:
				speed_type = Types.SpeedTypes.NONE  # Valor default (normal)
				
		change_current_text_speed(speed_type)
		change_speed_by_enum(speed_type)
		return "Velocidade alterada para " + Types.wrap_system_text(second_word)
	else:
		return "Esse valor de velocidade não é válido. Escolha entre lenta, normal ou rápida"
	
func change_speed_by_enum(new_speed : Types.SpeedTypes):
	speed_changed.emit(new_speed)
	
func change_current_text_speed(new_speed : Types.SpeedTypes):
	current_speed = new_speed
		
func take(second_word : String) -> String:
	if second_word == "":
		change_speed_by_enum(Types.SpeedTypes.NONE)
		return Types.wrap_system_text("Pegar o que?")
		
	var item_wanted : Item
	
	item_wanted = current_room.has_item_on_room(second_word.to_lower())
	
	if item_wanted != null:
		current_room.remove_item(item_wanted)
		player.take_item(item_wanted)
		change_speed_by_enum(current_speed)
		return "Você pegou " + Types.wrap_item_text(item_wanted.item_name)
		
	change_speed_by_enum(current_speed)
	return Types.wrap_system_text("Aqui não tem nenhum item com esse nome...")
	
func describe_item(second_word : String, third_word : String = "") -> String:	
	if second_word == "":
		change_speed_by_enum(Types.SpeedTypes.NONE)
		return Types.wrap_system_text("Descrever o que?")
		
	var item_wanted : Item
	var item_wanted_name : String
	
	change_speed_by_enum(current_speed)
	
	if third_word == "":
		item_wanted_name = second_word.to_lower()
		item_wanted = current_room.has_item_on_room(item_wanted_name)
		if item_wanted == null:	
			item_wanted = player.has_item_on_inventory(item_wanted_name)
	else:
		item_wanted_name = second_word.to_lower().capitalize() + " " + third_word.to_lower().capitalize()
		item_wanted = current_room.has_item_on_room(item_wanted_name, true)
		if item_wanted == null:	
			item_wanted = player.has_item_on_inventory(item_wanted_name, true)
		
	if item_wanted != null:
		return "Sobre " + Types.wrap_item_text(item_wanted.item_name) + ": " + item_wanted.use_value_description
	else:	
		return Types.wrap_system_text("Aqui não tem nenhum item com esse nome...")
	
func drop(second_word : String) -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	if second_word == "":
		return Types.wrap_system_text("Dropar o que?")
		
	var item_wanted : Item
	
	item_wanted = player.has_item_on_inventory(second_word.to_lower())
	
	if item_wanted != null:
		current_room.add_item(item_wanted)
		change_speed_by_enum(current_speed)
		return player.drop_item(item_wanted)
	else:
		return Types.wrap_system_text("Você não tem esse item no seu inventário.")
	
func use(second_word : String, third_word : String) -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
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
					player.drop_item(item_wanted)
					change_speed_by_enum(current_speed)
					return current_room.unlock_exit(third_word, current_room)
					
				else:
					return Types.wrap_system_text("Essa não é uma direção válida")
			_:
				return Types.wrap_system_text("Esse não é um item válido")
			
	return Types.wrap_system_text("Você não tem esse item no seu inventário.")
	
func give(second_word : String, third_word : String) -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
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
				
				var reward : Item
				change_speed_by_enum(current_speed)
				
				if npc_wanted.reward_item != null:
					reward = npc_wanted.give_reward_to_player()
					player.take_item(reward, false)
					return player.give_item(item_wanted) + " para " + Types.wrap_npc_text(third_word) + " e recebeu " + Types.wrap_item_text(reward.item_name) + " como recompensa!"
				else:
					return player.give_item(item_wanted) + " para " + Types.wrap_npc_text(third_word) 
			else:
				return Types.wrap_system_text("This person doesn't need this item")
				
		return Types.wrap_system_text("There no person with this name in this room")
			
	return Types.wrap_system_text("This is not a valid item from your inventory.")
	
func talk(second_word : String) -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	if second_word == "":
		return Types.wrap_system_text("Talk to whom?")
		
	var npc_wanted : NPC
	var return_string : String = ""
	
	npc_wanted = current_room.is_npc_on_room(second_word.to_lower())
		
	if npc_wanted != null:
		change_speed_by_enum(current_speed)
		var npc_type : Types.NPCTypes = npc_wanted.get_type()
		
		match npc_type:
			
			Types.NPCTypes.GIVE_QUEST:
				if !npc_wanted.has_talked_to_npc:
					return_string += Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\" \n" + player.add_quest(npc_wanted.quest_related) # + "\n" + current_room.get_exits_description()
					
			Types.NPCTypes.COMPLETE_QUEST:
				if !npc_wanted.has_talked_to_npc:
					var quest : Quest = npc_wanted.quest_related
					return_string += player.remove_quest(quest) + "\n"+ Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
					
			Types.NPCTypes.NEED_ITEM:

				var item_wanted : Item
				item_wanted = player.has_item_on_inventory(npc_wanted.required_item.item_name, true)
				
				if item_wanted != null:
					
					if npc_wanted.required_item.item_type == Types.ItemTypes.TRANSLATOR:
						return_string += Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_translated_dialog() + "\""
					else:
						return_string += Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + npc_wanted.get_extra_dialog() + "\""
						
					if npc_wanted.reward_item != null and !npc_wanted.has_given_reward:
						room_manager.add_item(current_room, npc_wanted.reward_item.item_name)
						npc_wanted.has_given_reward = true
						return_string += "\n" + current_room.get_items_description()
				
								
			Types.NPCTypes.SEAL_PUP:
				var quest : Quest = npc_wanted.quest_related
				var player_has_quest = player.has_quest(quest)
				
				if !player_has_quest and !npc_wanted.has_received_quest_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + player.add_quest(quest)
				elif player_has_quest and !npc_wanted.has_received_quest_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
				elif player_has_quest and npc_wanted.has_received_quest_item:
					current_room.connect_exit("praia", $"../RoomManager/Praia", "oeste", false)
					return player.remove_quest(quest) + "\n" +Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + current_room.get_exits_description()	
				elif !player_has_quest and npc_wanted.has_received_quest_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + current_room.get_exits_description()	
			
			Types.NPCTypes.SEAL_MOM:
				var quest : Quest = npc_wanted.quest_related
				var player_has_quest = player.has_quest(quest)
				var item_wanted = player.has_item_on_inventory(npc_wanted.reward_item.item_name, true)
				var npc_given_item = npc_wanted.has_given_reward
				
				if !player_has_quest and item_wanted == null:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\"" + "\n" + player.add_quest(quest) + "\n" + player.take_item(npc_wanted.give_reward_to_player())
				elif player_has_quest and item_wanted == null and !npc_given_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_extra_dialog() + npc_wanted.get_dialog() + "\"" + "\n" + player.take_item(npc_wanted.give_reward_to_player())
				elif player_has_quest and item_wanted != null and npc_given_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_extra_dialog() + npc_wanted.get_dialog() + "\""
				elif !player_has_quest and item_wanted == null and npc_given_item:
					return Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_post_dialog()
			
			_:
				pass
		
		if npc_wanted.paths_to_unlock.size() > 0:
			var paths_keys = npc_wanted.paths_to_unlock.keys()
			for key in paths_keys:
				return_string += "\n" + room_manager.connect_exit(current_room.room_name, str(key) , npc_wanted.paths_to_unlock[key])
				
		if npc_wanted.disappear_after_talk:
			current_room.remove_npc(npc_wanted)
			return_string += "\n" + current_room.remove_npc(npc_wanted)
			
		if npc_wanted.reward_item != null and npc_wanted.required_item == null and !npc_wanted.has_given_reward:
			room_manager.add_item(current_room, npc_wanted.reward_item.item_name)
			npc_wanted.has_given_reward = true
			return_string += "\n" + current_room.get_items_description()
		
		if return_string == "":		
			return_string = Types.wrap_npc_text(npc_wanted.npc_name) + ": \"" + npc_wanted.get_dialog() + "\""
		return return_string
	
	return Types.wrap_system_text("Essa pessoa não está aqui!")
	
func inventory() -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	return player.get_inventory()
	
func quests() -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	return player.get_quests()
	
func exits() -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	return current_room.get_exits_description()
	
func help() -> String:
	change_speed_by_enum(Types.SpeedTypes.NONE)
	return "\n".join(PackedStringArray([
		"Você pode usar os comandos abaixo: ",
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
		" velocidade " + Types.wrap_system_text("[lenta, normal, rápida]") + " altera a velocidade do texto"+ ",",
		" aperte " + Types.wrap_attention_text("CTRL") + " para acelerar o texto"+ ",",
		" ajuda"
	]))
	
func change_room(new_room : Room) -> String:
	change_speed_by_enum(current_speed)
	
	if current_room != null:
		if current_room.audio != new_room.audio and new_room.audio != null:
			new_room.play_audio()
	else:
		new_room.play_audio()
		
	current_room = new_room
	
	return new_room.get_full_description()
	
		
	
