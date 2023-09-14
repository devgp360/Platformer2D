extends Node2D


@export var num = "1" # Numero de conteo
@onready var canvas = $Num # Contador
@onready var animation = $PowerUpItem # Animación

# Mapeo de animación y diálogos
var _dialogues = {
	"blue_potion": "res://scenes/game/dialogues/dialogues/power_up/blue_potion_item.dialogue",
	"green_bottle": "res://scenes/game/dialogues/dialogues/power_up/green_bottle_item.dialogue",
}


func _ready():
	canvas.text = num

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
