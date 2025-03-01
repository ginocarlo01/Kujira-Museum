extends MarginContainer
class_name Input_Response

@onready var zebra = $Zebra
@onready var input_label = $Rows/InputHistory
@onready var response_label = $Rows/Response

var finished_set_text : bool = false
var cancel_animation : bool = false

func cancel_text_animation():
	cancel_animation = true

# Função que vai animar a escrita do texto
func set_text(response: String, input: String = "", speed: Types.SpeedTypes = Types.SpeedTypes.NORMAL) -> bool:
	cancel_animation = false
	
	# Se o input não for vazio, define o texto do input_label
	if input == "":
		input_label.queue_free()
	else:
		input_label.text = " > " + input
	
	var delay_time: float
	delay_time = Types.SpeedValues[speed]

	response_label.text = ""
	await _animate_text(response, delay_time)
	finished_set_text = true
	return true

# Função que processa todo o texto de uma vez (respeitando as regras de formatação)
func _process_all_text(text: String) -> String:
	return text

# Função que adiciona o texto aos poucos com tratamento especial para trechos delimitados por tags []
func _animate_text(text: String, delay_time: float) -> void:
	var current_text: String = ""
	var i: int = 0
	
	if delay_time == 0.0:
		response_label.text = _process_all_text(text)
		return
	
	while i < text.length():
		if Input.is_key_pressed(KEY_CTRL) or cancel_animation:
			response_label.text = _process_all_text(text)
			return

		if text[i] == '[':
			# 1. Captura a primeira tag (incluindo o próprio '[' e até o ']')
			var temp1: String = ""
			while i < text.length() and text[i] != ']':
				temp1 += text[i]
				i += 1
			if i < text.length() and text[i] == ']':
				temp1 += text[i]  # Adiciona o ']'
				i += 1  # Pula o ']'
			
			# 2. Captura e anima o texto entre o ']' e o próximo '['
			var middle_text: String = ""
			while i < text.length() and text[i] != '[':
				if Input.is_key_pressed(KEY_CTRL) or cancel_animation:
					response_label.text = _process_all_text(text)
					return

				middle_text += text[i]
				current_text += text[i]
				response_label.text = current_text
				await get_tree().create_timer(delay_time).timeout
				i += 1
			
			# 3. Captura a segunda tag (de '[' até ']')
			var temp2: String = ""
			if i < text.length() and text[i] == '[':
				while i < text.length() and text[i] != ']':
					temp2 += text[i]
					i += 1
				if i < text.length() and text[i] == ']':
					temp2 += text[i]
					i += 1
			# 4. Atualiza imediatamente o texto: reinserindo as tags ao redor do trecho animado
			var base_text: String = current_text.substr(0, current_text.length() - middle_text.length())
			current_text = base_text + temp1 + middle_text + temp2
			response_label.text = current_text
		else:
			current_text += text[i]
			response_label.text = current_text
			await get_tree().create_timer(delay_time).timeout
			i += 1
