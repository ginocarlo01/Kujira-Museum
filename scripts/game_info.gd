# Responsible for handling how things are displayed

extends PanelContainer

@onready var scroll = $Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var history_rows = $Scroll/HistoryRows
@onready var command_processor = $"../../../../CommandProcessor"

@export var max_lines_remembered := 30 
@export var text_speed : Types.SpeedTypes = Types.SpeedTypes.NORMAL

var should_zebra := false
var is_npc_talking := false
var npc_picture_path : String

const INPUT_RESPONSE = preload("res://scenes/input_response.tscn")
var last_input_response : Input_Response = null

func _ready() -> void:
	scrollbar.changed.connect(_handle_scrollbar_changed)
	command_processor.speed_changed.connect(_set_text_speed)
	command_processor.npc_is_talking.connect(_npc_is_talking)
	
	
func _npc_is_talking(path : String):
	npc_picture_path = path
	is_npc_talking = true
	
# Public Functions:
func create_response(response_text : String, fast_response = false) -> bool:
	var response = INPUT_RESPONSE.instantiate()
	
	_add_response_to_history(response)
	
	if is_npc_talking:
		is_npc_talking = false
		if npc_picture_path != "":
			response.set_npc_picture(npc_picture_path)
		npc_picture_path = ""
		response.is_npc_talking = true
	
	if fast_response: 
		return await response.set_text(response_text, "", Types.SpeedTypes.NONE)
	else:
		return await response.set_text(response_text, "", text_speed)
	
func create_response_with_input(response_text : String, input_text : String):
	var input_response = INPUT_RESPONSE.instantiate()
	_add_response_to_history(input_response)
	if is_npc_talking:
		is_npc_talking = false
		if npc_picture_path != "":
			input_response.set_npc_picture(npc_picture_path)
		input_response.is_npc_talking = true
	input_response.set_text(response_text, input_text, text_speed)

# Private Functions:
func _set_text_speed(new_text_speed : Types.SpeedTypes):
	text_speed = new_text_speed

func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value
	
func _delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_children()[0].queue_free()

func _add_response_to_history(response: Control):
	if last_input_response != null:
		if !last_input_response.finished_set_text:
			last_input_response.cancel_text_animation()
	last_input_response = response
	history_rows.add_child(response)
	if !should_zebra:
		response.zebra.hide()
	should_zebra = !should_zebra
	_delete_history_beyond_limit()
