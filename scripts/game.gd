extends Control

#On Ready Garante que só vai ser acessado se o objeto já foi iniciado
@onready var game_info = $Background/MarginContainer/Rows/GameInfo
@onready var command_processor = $CommandProcessor
@onready var room_manager = $RoomManager
@onready var player = $Player

@export_multiline var initial_text := ""

func _ready() -> void:
	game_info.create_response(Types.wrap_system_text(initial_text) + "Para pedir orientações, digite " + Types.wrap_attention_text("ajuda"))
	
	var starting_room_response =  command_processor.initialize(room_manager.get_child(0), player, room_manager)
	game_info.create_response(starting_room_response)
	
func _on_input_text_submitted(input_text: String) -> void:
	if input_text.is_empty():
		return
		
	var response = command_processor.process_command(input_text)
	response = Types.manipulate_string(response)
	game_info.create_response_with_input(response, input_text)
