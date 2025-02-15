extends Control

const InputResponse = preload("res://scenes/input_response.tscn")

@onready var history_rows = $Background/MarginContainer/Rows/GameInfo/Scroll/HistoryRows
#On Ready Garante que só vai ser acessado se o objeto já foi iniciado

@onready var scroll = $Background/MarginContainer/Rows/GameInfo/Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()

func _ready() -> void:
	scrollbar.changed.connect( handle_scrollbar_changed)
	
func handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value

func _on_input_text_submitted(new_text: String) -> void:
	var input_response = InputResponse.instantiate()
	input_response.set_text(new_text, "This is the response!")
	history_rows.add_child(input_response)
	
