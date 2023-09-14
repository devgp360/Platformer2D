extends Node2D
## Controlador de lanzamiento de bombas.
##
## Escucha la tecla de tirar bombas y tira la bomba


# Precargamos la escena de la bomba
var _bomb = preload("res://scenes/game/levels/objects/damage_object/bomb/bomb.tscn")
# El script de movimiento
var _move_script: Node2D


func _ready():
	HealthDashboard.add_bomb(2)
	_move_script = get_parent().get_node("MainCharacterMovement")


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	# Validamos cuantas bombas tenemos
	var _count_bomb = HealthDashboard.points["Bomb"]
	# Cuando se presiona la tecla (B - bomb) y no tiramos la bomba antes
	if event.is_action_released("bomb") and not _move_script.bombing and _count_bomb > 0:
		# Quitamos la bomba del invetario
		HealthDashboard.add_bomb(-1)
		# Inicializamos la bomba
		var bomb_scene = _bomb.instantiate()
		# Seteamos la posisión a la par del personaje principal
		var _character = get_parent()
		var _character_position = _character.position
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
