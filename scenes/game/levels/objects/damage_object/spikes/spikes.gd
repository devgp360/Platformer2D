extends Node
## Script para objeto que hace daño "spike"
##
## Al entrar en contacto con este objeto, el personaje pierda toda la vida


var _player_script: Node2D # Referencia al script del jugador, para poder bajar vida

@onready var _timer = $Timer # Variable para temporizar el daño


# Escuchamos cuando un "cuerpo" entra en el área de contacto
func _on_area_body_entered(body):
	if body.is_in_group("player"):
		_player_script = body.get_node("MainCharacterMovement")
		# "Golpeamos" al personaje
		_player_script.hit(2)
		# Iniciamos el temporizador
		_timer.start()


# Escuchamos cuando un "cuerpo" sale del área de contacto
func _on_area_body_exited(body):
	# Al salir de los "picos", borramos la variable para no seguir haciendo daño
	_player_script = null


# Escuchamos cuando se acaba el temporizador
func _on_timer_timeout():
	# Si no está activo el "script" del jugador, terminamos la función
	if not _player_script:
		return
	# Si el jugador ya no tiene vida, terminamos la función
	if HealthDashboard.life <= 0:
		return
	# Cuando termina el temporizador, hacemos daño al jugador
	_player_script.hit(2)
	# Luego procedemos a inicializar de nuevo el temporizador
	_timer.start()
