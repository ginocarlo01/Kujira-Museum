# Responsible for handling how things are displayed

extends PanelContainer

@onready var scroll = $Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var history_rows = $Scroll/HistoryRows
@onready var command_processor = $"../../../../CommandProcessor"

@export var max_lines_remembered := 30 
@export var text_speed : String = "normal"

var should_zebra := false

const INPUT_RESPONSE = preload("res://scenes/input_response.tscn")

func _ready() -> void:
	scrollbar.changed.connect(_handle_scrollbar_changed)
	command_processor.speed_changed.connect(_set_text_speed)
	
# Public Functions:
func create_response(response_text : String, fast_response = false):
	var response = INPUT_RESPONSE.instantiate()
	_add_response_to_history(response)
	if fast_response: 
		response.set_text(response_text, "", "none")
	else:
		response.set_text(response_text, "", text_speed)
	
func create_response_with_input(response_text : String, input_text : String):
	var input_response = INPUT_RESPONSE.instantiate()
	_add_response_to_history(input_response)
	input_response.set_text(response_text, input_text, text_speed)

# Private Functions:
func _set_text_speed(new_text_speed : String):
	text_speed = new_text_speed

func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value
	
func _delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_children()[0].queue_free()

func _add_response_to_history(response: Control):
	history_rows.add_child(response)
	if !should_zebra:
		response.zebra.hide()
	should_zebra = !should_zebra
	_delete_history_beyond_limit()
