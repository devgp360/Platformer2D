extends Node
## Script para diálogos customizados
##
## Crea y muestra diálogos, usando una visualización customizada


# Definición del template (custom) del diálogo
var _path_custom_dialogue = "res://scenes/game/dialogues/balloon/balloon.tscn"
var _custom_dialogue: PackedScene


# Función de inicialización
func _ready():
	_custom_dialogue = load(_path_custom_dialogue)


# Creamos un nuevo diálogo y lo retornamos
func create():
	var _dialog = _custom_dialogue.instantiate()
	return _dialog


# Mostramos el diálogo
func show_dialogue(_dialog: Node, _resource: DialogueResource, _start = "start"):
	# Agregamos el diálogo a la escena actual
	get_tree().current_scene.add_child(_dialog)
	# Inicimos (mostramos) el diálogo
	_dialog.start(_resource, _start)


# Creamos y mostramos el diálogo (retornamos el diálogo)
func create_and_show_dialogue(_resource: DialogueResource, _start = "start"):
	var _dialog = create()
	show_dialogue(_dialog, _resource, _start)
	return _dialog
