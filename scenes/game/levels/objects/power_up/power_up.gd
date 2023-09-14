extends AnimatedSprite2D
## Script de objetos recolectables con diálogos
##
## Este objeto se guarda en inventario. También muestra un diálogo de información del objeto


# Mapeo de animación y diálogos
var _dialogues = {
	"blue_potion": "res://scenes/game/dialogues/dialogues/power_up/blue_potion.dialogue",
	"green_bottle": "res://scenes/game/dialogues/dialogues/power_up/green_bottle.dialogue",
}
var _move: Node2D # Para poder deshabilitar el personaje


# Función de inicialización
func _ready():
	play()


# Mostramos el diálogo
func _show_dialogue():
	var _resource = _dialogues[animation]
	var _instance = load(_resource)
	var _dialogue = CustomDialogue.create_and_show_dialogue(_instance)
	_dialogue.on_dialogue_ended(_on_dialogue_ended)


# Escuchamos cuando un "cuerpo" entra al área del objeto
func _on_area_body_entered(body):
	if body.is_in_group("player"):
		# Si es el "jugador" lo "deshabilitamos", y mostramos el diálogo
		_show_dialogue()
		_move = body.get_node("MainCharacterMovement")
		_move.set_disabled(true)
		_move.set_idle()


# Al recoger el objeto, hacemos animación de recoger, y al terminar activamos el personaje y liberamos memoria
func _pick_up():
	# Sumar items de inventario
	InventoryCanvas.add_item_by_name(animation)
	# Hacer animación y eliminar el item de la escena
	play("pick_up")
	await animation_finished
	_move.set_disabled(false)
	queue_free()


# Escuchamos cuando el diálogo terminte
func _on_dialogue_ended():
	_pick_up()
