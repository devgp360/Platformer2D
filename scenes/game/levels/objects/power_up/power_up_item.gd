extends Node2D
## Script de objetos de inventario
##
## Este objeto al utilizarse, mostrará un diálogo informativo


var _is_active = false # Para saber si el puntero está en el item

@export var num = "1" # Numero de conteo
@onready var canvas = $Num # Contador
@onready var animation = $PowerUpItem # Animación
@onready var _confirm = $CanvasConfirm # Confirmación


# Mapeo de animación y diálogos
var _dialogues = {
	"blue_potion": "res://scenes/game/dialogues/dialogues/power_up/blue_potion_item.dialogue",
	"green_bottle": "res://scenes/game/dialogues/dialogues/power_up/green_bottle_item.dialogue",
}


# Función de inicialización
func _ready():
	canvas.text = num
	HealthDashboard.visible = false


# Función para detectar eventos de teclado y ratón
func _unhandled_input(event):
	if not _is_active:
		return # Si el puntero no está sobre el item, terminamos la función
	# Si hacemos clic, mostramos el diálogo de confirmación
	if event is InputEventMouseButton and event.is_released():
		_confirm.show()


# Mostramos el diálogo
func show_dialogue():
	var _resource = _dialogues[animation]
	var _instance = load(_resource)
	var _dialogue = CustomDialogue.create_and_show_dialogue(_instance)
	_dialogue.on_dialogue_ended(_on_dialogue_ended)


# Escuchamos cuando termina el diálogo
func _on_dialogue_ended():
	pass


# Actualizamos la cantidad disponible
func set_num(_num: String):
	canvas.text = _num


# Obtenemos la cantidad disponible
func get_num():
	return int(canvas.text)


# Escuchamos cuando el puntero entra en el item
func _on_area_mouse_entered():
	_is_active = true


# Escuchamos cuando el puntero sale del item
func _on_area_mouse_exited():
	_is_active = false


# Cuando se presiona el botón "cancelar"
func _on_cancel_pressed():
	_confirm.hide()
