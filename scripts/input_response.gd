extends MarginContainer

@onready var zebra = $Zebra
@onready var input_label = $Rows/InputHistory
@onready var response_label = $Rows/Response

# Função que vai animar a escrita do texto
func set_text(response : String, input : String = "", speed : String = "normal"):
	# Se o input não for vazio, define o texto do input_label
	if input == "":
		input_label.queue_free()
	else:
		input_label.text = " > " + input
	
	# Define a velocidade para cada tipo
	var delay_time : float 
	match speed:
		"slow" : 
			delay_time = 0.1    # Lento
		"normal" : 
			delay_time = 0.05 # Normal
		"fast" : 
			delay_time = 0.02   # Rápido
		_ : 
			0.05         # Valor default (normal)
	
	# Começa a animação para adicionar o texto
	response_label.text = ""  # Limpa o texto anterior
	_animate_text(response, delay_time)

# Função que adiciona o texto aos poucos
func _animate_text(text : String, delay_time : float):
	var current_text : String = ""
	
	for i in range(text.length()):
		current_text += text[i]  # Adiciona o próximo caractere
		response_label.text = current_text  # Atualiza o texto
		await get_tree().create_timer(delay_time).timeout # Aguarda o delay
