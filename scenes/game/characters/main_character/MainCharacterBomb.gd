extends Node2D
## Controlador de lanzamiento de bombas.
##
## Escucha la tecla de tirar bombas y tira la bomba

# Precargamos la escena de la bomba
var _bomb = preload("res://scenes/game/levels/objects/damage_object/bomb/bomb.tscn")
# La bandera de que la bomba fue tirada
var _launch = false

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	# Cuando se presiona la tecla (B - bomb) y no tiramos la bomba antes
	if Input.is_action_pressed("bomb") and not _launch:
		# Seteamos la bandera de bomba lanzada a true
		_launch = true
		# Inicializamos la bomba
		var bomb_scene = _bomb.instantiate()
		# Seteamos la posisión a la par del personaje principal
		var _character = get_parent()
		var _character_position = _character.position
		var _move_script = _character.get_node("MainCharacterMovement")
		bomb_scene.position = _character_position
		# Seteamos la dirección de la fuerza y offset
		if _move_script.turn_side == "right":
			bomb_scene.linear_velocity.x = abs(bomb_scene.linear_velocity.x)
			bomb_scene.position.x = _character_position.x + 25
		else:
			bomb_scene.linear_velocity.x = - abs(bomb_scene.linear_velocity.x)
			bomb_scene.position.x = _character_position.x - 25
	
		# Agregamos la bomba a la escena
		get_parent().get_parent().add_child(bomb_scene)
		# Esperamos 1 segundo
		await get_tree().create_timer(1).timeout
		# Liberamos la posibilidad de lanzar bombas
		_launch = false
