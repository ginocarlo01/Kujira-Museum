# Responsible for handling how things are displayed

extends PanelContainer

@onready var scroll = $Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var history_rows = $Scroll/HistoryRows

@export var max_lines_remembered := 30 

var should_zebra := false

const INPUT_RESPONSE = preload("res://scenes/input_response.tscn")

func _ready() -> void:
	scrollbar.changed.connect(_handle_scrollbar_changed)
	
# Public Functions:
func create_response(response_text : String):
	var response = INPUT_RESPONSE.instantiate()
	_add_response_to_history(response)
	response.set_text(response_text)
	
func create_response_with_input(response_text : String, input_text : String):
	var input_response = INPUT_RESPONSE.instantiate()
	_add_response_to_history(input_response)
	input_response.set_text(response_text, input_text)

# Private Functions:
func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value
	
func _delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_children()[0].queue_free()

func _add_response_to_history(response: Control):
	history_rows.add_child(response)
	if !should_zebra:
		response.zebra.hide()
	should_zebra != should_zebra
	_delete_history_beyond_limit()
