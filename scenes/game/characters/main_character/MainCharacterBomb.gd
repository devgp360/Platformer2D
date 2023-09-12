extends Node2D
## Controlador de lanzamiento de bombas.
##
## Escucha la tecla de tirar bombas y tira la bomba


var bomb = preload("res://scenes/game/levels/objects/damage_object/bomb/bomb.tscn")


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	# Cuando se presiona la tecla (flecha izquierda), movemos el personaje a la izquierda
	if Input.is_action_pressed("bomb"):
		var bomb_scene = bomb.instantiate()
		var _character_position = get_parent().position
		print(_character_position.x)
		bomb_scene.position.x = _character_position.x + 25
		get_parent().get_parent().add_child(bomb_scene)
