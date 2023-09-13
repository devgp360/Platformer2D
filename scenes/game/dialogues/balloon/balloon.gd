extends CanvasLayer
## Clase que controla Dialogos
##
## Se realizan las preparaciones de textos para dialogos, se controla la orden en que aparecen los textos
## La logica de recibir las respuestas del jugador, calculos de tamaños de dialogo cuando se cambia el tamaño de la ventana de juego 


# DOCUMENTACIÓN TOOLTIPS PARA DIÁLOGOS CON NPCS: https://docs.google.com/document/d/15bKBdC0nMawhdyuVRRfcZbFD7D59Lb8HhKiGBY70FL0
# DOCUMENTACIÓN ¿QUÉ SON LAS SEÑALES EN GDSCRIPT?: https://docs.google.com/document/d/1bbroyXp11L4_FpHpqA-RckvFLRv3UOE-hmQdwtx27eo

# Señal de finalizacion de diálogo
signal dialogue_ended()
# Señal que se lanza cuando se elige una respuesta
signal response_selected(response: String)

const PATH_SPRITES = "res://scenes/game/dialogues/persons/"

# Exportamos plantilla de respuestas
@export var response_template: Node

# Recurso del diálogo
var _resource: DialogueResource
# Estados del juego temporal
var _temporary_game_states: Array = []
# Variable que valida si estamos esperando la respuesta del jugador
var _is_waiting_for_input: bool = false
# Hilo del dialogo
var dialogue_line: DialogueLine:
	# Creamos la linea del dialogo
	set(next_dialogue_line):
		# Si no existen textos
		if not next_dialogue_line:
			# Finalizamos y retornamos
			return _end_dialogue()
		
		# No esperamos la respuesta del jugador
		_is_waiting_for_input = false
		
		# Eliminamos respuestas enteriores
		for child in responses_menu.get_children():
			responses_menu.remove_child(child)
			child.queue_free()
		
		# Asignamos el ptimer diálogo
		dialogue_line = next_dialogue_line
		# Mostramos el diálogo
		character_label.visible = not dialogue_line.character.is_empty()
		# Mostramos el titulo
		character_label.text = tr(dialogue_line.character, "dialogue")
		# Eliminamos los nodos insertados
		for n in portrait_node.get_children():
			portrait_node.remove_child(n)
			n.queue_free()
		# Mostramos el avatar
		portrait_node.add_child(_get_texture_for_dialogue(dialogue_line.character))
		
		# Ajustamos las propiedades del diálogo
		dialogue_label.modulate.a = 0
		dialogue_label.custom_minimum_size.x = dialogue_label.get_parent().size.x - 1
		dialogue_label.dialogue_line = dialogue_line
		
		# Mostramos respuestas si existen
		responses_menu.modulate.a = 0
		if dialogue_line.responses.size() > 0:
			for response in dialogue_line.responses:
				# Duplicamos la plantilla para poder usar los estilos
				var item: RichTextLabel = response_template.duplicate(0)
				item.name = "Response%d" % responses_menu.get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.modulate.a = 0.4
				item.text = response.text
				item.show()
				responses_menu.add_child(item)
		
		# Mostramos el dialogo
		balloon.show()
		
		dialogue_label.modulate.a = 1
		dialogue_label.type_out()
		await dialogue_label.finished_typing
		
		# Esperamos la respuesta del jugador
		if dialogue_line.responses.size() > 0:
			responses_menu.modulate.a = 1
			_configure_menu()
		elif dialogue_line.time != null:
			# Pasamos al siguiente diálogo
			var time = (
				dialogue_line.dialogue.length() * 0.02 if dialogue_line.time == "auto" 
				else dialogue_line.time.to_float()
			)
			await get_tree().create_timer(time).timeout
			_next(dialogue_line.next_id)
		else:
			_is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line # Retornamos la linea del diálogo

# Definición del dialogo
@onready var balloon: ColorRect = $Balloon
# Definición del nodo de margin
@onready var margin: MarginContainer = $Balloon/Margin
@onready var portrait_node: Control = $Balloon/Margin/HBox/Portrate
# Definición del nodo del avatar
@onready var character_portrait: Sprite2D = $Balloon/Margin/HBox/Portrate/Sprite2D
# Definición del nodo del nombre del personaje
@onready var character_label: RichTextLabel = $Balloon/Margin/HBox/VBox/CharacterLabel
# Definición del nodo del diálogo
@onready var dialogue_label := $Balloon/Margin/HBox/VBox/DialogueLabel
# Definición del nodo de respuestas
@onready var responses_menu: VBoxContainer = $Balloon/Margin/HBox/VBox/Responses
# Puedes leer más sobre nodos en éste documento: https://docs.google.com/document/d/1AiO1cmB31FSQ28me-Rb15EQni8Pyomc1Vgdm1ljL3hc


# Función que se llama cuando la escena esta cargada
func _ready() -> void:
	# Escondemos el giálogo
	response_template.hide()
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(_event: InputEvent) -> void:
	# Seteamos que el diálogo reciba las respuestas del jugador
	get_viewport().set_input_as_handled()


# Iniciamos el diálogo
func start(dialogue_resource: DialogueResource, 
		title: String, extra_game_states: Array = []) -> void:
	_temporary_game_states = extra_game_states
	_is_waiting_for_input = false
	_resource = dialogue_resource
	# Seteamos los textos del diálogo
	self.dialogue_line = await _resource.get_next_dialogue_line(title, _temporary_game_states)


# Go to the next line
func _next(next_id: String) -> void:
	self.dialogue_line = await _resource.get_next_dialogue_line(next_id, _temporary_game_states)


# Escuchamos los botones y señales de respuestas
func _configure_menu() -> void:
	balloon.focus_mode = Control.FOCUS_NONE
	
	var items = _get_responses()
	for i in items.size():
		var item: Control = items[i]
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()
		
		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()
		
		item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		item.gui_input.connect(_on_response_gui_input.bind(item))
	
	items[0].grab_focus()


# Obtenemos la lista de respuestas disponibles
func _get_responses() -> Array:
	var items: Array = []
	for child in responses_menu.get_children():
		if "Disallowed" in child.name: continue
		items.append(child)
		
	return items


# Ajustamos el tamaño del dialogo
func _handle_resize() -> void:
	if not is_instance_valid(margin):
		call_deferred("_handle_resize")
		return
	
	balloon.custom_minimum_size.y = margin.size.y
	balloon.size.y = 0
	var viewport_size = balloon.get_viewport_rect().size
	balloon.global_position = Vector2(
		(viewport_size.x - balloon.size.x) * 0.5, 
		viewport_size.y - balloon.size.y)


# Escondemos el diálogo
func _on_mutated(_mutation: Dictionary) -> void:
	_is_waiting_for_input = false
	balloon.hide()


# Escuchamos cuando el raton entra al area de respuestas
func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: 
		return
	item.grab_focus()


# Seteamos las respuestas elegidas
func _on_response_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name: 
		return
	# Pasamos a la siguiente linea de diálogo
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		response_selected.emit(dialogue_line.responses[item.get_index()].text)
		_next(dialogue_line.responses[item.get_index()].next_id)
	elif event.is_action_pressed("ui_accept") and item in _get_responses():
		response_selected.emit(dialogue_line.responses[item.get_index()].text)
		_next(dialogue_line.responses[item.get_index()].next_id)


# Seteamos las siguientes lineas de dialogos
func _on_balloon_gui_input(event: InputEvent) -> void:
	if not _is_waiting_for_input: 
		return
	# Salimos si no hay mas texto
	if dialogue_line.responses.size() > 0: return

	# Cuando no hay respuestas damos la opción de hacer clicks en el diálogo
	get_viewport().set_input_as_handled()
	
	# Con el click cambiamos las lineas de diálogo
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		_next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		_next(dialogue_line.next_id)


# Si cambia la reslución recalculamos el tamaño del dialogo
func _on_margin_resized() -> void:
	_handle_resize()


# Se carga la imagen del personaje que esté dialogando
func _get_texture_for_dialogue(character: String):
	# Obtenemos el primer nombre
	var person = character.to_lower().split(" ")[0]
	# Definimos la escena a insertar
	var filename = "%s/" % [person] + "%s.tscn" % [person]
	# Retornamos el avatar
	return load(PATH_SPRITES + filename).instantiate()


# Se ejecuta cuando el diálogo finaliza
func _end_dialogue():
	# Terminamos el diálogo
	queue_free()
	# Emitimos la señal de finalización de dialogo
	self.emit_signal("dialogue_ended")


# Conectamos la finalización del diálogo (para escuchar cuando termina el diálogo)
func on_dialogue_ended(fn):
	dialogue_ended.connect(fn)


# Conectamos la señal para obtener respuestas seleccionadas en el diálogo
func on_response_selected(fn):
	response_selected.connect(fn)
