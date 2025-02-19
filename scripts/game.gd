extends Control

const Response = preload("res://scenes/response.tscn")
const InputResponse = preload("res://scenes/input_response.tscn")

@onready var history_rows = $Background/MarginContainer/Rows/GameInfo/Scroll/HistoryRows
#On Ready Garante que só vai ser acessado se o objeto já foi iniciado
@onready var command_processor = $CommandProcessor
@onready var room_manager = $RoomManager
@onready var scroll = $Background/MarginContainer/Rows/GameInfo/Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()

@export var max_lines_remembered := 30 

func _ready() -> void:
	scrollbar.changed.connect(handle_scrollbar_changed)
	
	create_response("Welcome to the retro text adventure ! You can type help to see available commands")
	
	#command_processor.response_generated.connect(handle_response_generated)
	var starting_room_response =  command_processor.initialize(room_manager.get_child(0))
	create_response(starting_room_response)
	
func handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_processor.process_command(new_text)
	var input_response = InputResponse.instantiate()
	input_response.set_text(new_text, response)
	add_response_to_history(input_response)
	
func create_response(response_text : String):
	var response = Response.instantiate()
	response.text = response_text
	add_response_to_history(response)
	
func add_response_to_history(response: Control):
	history_rows.add_child(response)
	delete_history_beyond_limit()
			
func delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_children()[0].queue_free()
