extends AnimatedSprite2D


# Mapeo de animación y diálogos
var _dialogues = {
	"blue_potion": "res://scenes/game/dialogues/dialogues/power_up/blue_potion_item.dialogue",
	"green_bottle": "res://scenes/game/dialogues/dialogues/power_up/green_bottle_item.dialogue",
}


# Mostramos el diálogo
func show_dialogue():
	var _resource = _dialogues[animation]
	var _instance = load(_resource)
	var _dialogue = CustomDialogue.create_and_show_dialogue(_instance)
	_dialogue.on_dialogue_ended(_on_dialogue_ended)


# Escuchamos cuando termina el diálogo
func _on_dialogue_ended():
	pass
