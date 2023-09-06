extends Node2D
## Controlador de movimiento y animación de un personaje.
##
## Detecta eventos de teclado para poder mover un personaje por un escenario
## y ajustar animaciones según el movimiento
## Movimiento básica de personaje: https://docs.google.com/document/d/1c9XXznR1KBJSr0jrEWjYIqfFuNGCGP2YASkXsFgEayU/edit


@export var character: CharacterBody2D # Referencia al personaje a mover
@export var main_animation: AnimatedSprite2D # Referencia al sprite del personaje

var gravity = 650 # Gravedad para el personaje
var velocity = 100 # Velocidad de movimiento en horizontal
var jump = 220 # Capacidad de salto, entre mayor el número más se puede saltar
# Mapa de movimientos del personaje
var _movements = {
	IDLE = "default",
	IDLE_WITH_SWORD = "idle_with_sword",
	LEFT_WITH_SWORD = "left_with_sword",
	RIGHT_WITH_SWORD = "run_with_sword",
	JUMP_WITH_SWORD = "jump_with_sword",
	FALL_WITH_SWORD = "fall_with_sword",
}
var _current_movement = _movements.IDLE # Variable de movimiento
var _is_jumping = false # Indicamos que el personaje está saltando
var _max_jumps = 2 # Máximo número de saltos
var _jump_count = 0 # Contador de saltos realizados


# Called when the node enters the scene tree for the first time.
func _ready():
	main_animation.play(_current_movement)
	# Si no hay un personaje, deshabilitamos la función: _physics_process
	if not character:
		set_physics_process(false)


# Función de ejecución de físicas
func _physics_process(_delta):
	_move(_delta)


# Función de movimiento general del personaje
func _move(delta):
	# Cuando se presiona la tecla (flecha izquierda), movemos el personaje a la izquierda
	if Input.is_action_pressed("izquierda"):
		character.velocity.x = -velocity
		_current_movement = _movements.LEFT_WITH_SWORD
	# Cuando se presiona la tecla (flecha derecha), movemos el personaje a la derecha
	elif Input.is_action_pressed("derecha"):
		character.velocity.x = velocity
		_current_movement = _movements.RIGHT_WITH_SWORD
	# Cuando no presionamos teclas, no hay movimiento
	else:
		character.velocity.x = 0
		_current_movement = _movements.IDLE
	
	# Cuando se presiona la tecla (espacio), hacemos animación de salto
	if Input.is_action_just_pressed("saltar"):
		if character.is_on_floor():
			_current_movement = _movements.JUMP_WITH_SWORD
			_is_jumping = true
			_jump_count += 1
		elif _is_jumping and _jump_count < _max_jumps:
			_current_movement = _movements.JUMP_WITH_SWORD
			_jump_count += 1

	_apply_gravity(delta)
	_set_animation()
	# Función de godot para mover y aplicar física y colisiones
	character.move_and_slide()


# Controla la animación según el movimiento del personaje
func _set_animation():
	if _is_jumping:
		# Movimiento de salto (animación de "salto")
		if character.velocity.y >= 0:
			# Estamos cayendo
			main_animation.play(_movements.FALL_WITH_SWORD)
		else:
			# Estamos subiendo
			main_animation.play(_movements.JUMP_WITH_SWORD)
	elif _current_movement == _movements.RIGHT_WITH_SWORD:
		# Movimiento hacia la derecha (animación "correr" no volteada)
		main_animation.play(_movements.RIGHT_WITH_SWORD)
		main_animation.flip_h = false
	elif _current_movement == _movements.LEFT_WITH_SWORD:
		# Movimiento hacia la izquierda (animación "correr" volteada)
		main_animation.play(_movements.RIGHT_WITH_SWORD)
		main_animation.flip_h = true
	else:
		# Movimiento por defecto (animación de "reposo")
		main_animation.play(_movements.IDLE_WITH_SWORD)


# Función que aplica gravedad de caída o salto
func _apply_gravity(delta):
	var v = character.velocity
	
	# El salto solo se ejecuta 1 vez, en ese momento hacemos que el personaje salte
	if _current_movement == _movements.JUMP_WITH_SWORD:
		v.y = -jump
	else:
		# Aplicación de gravedad (aceleración en la caida)
		v.y += gravity * delta
		# Después de un salto, validamos cuando volvemos a tocar el suelo para poder volver a saltar
		if character.is_on_floor():
			# Reseteamos variables de salto
			_is_jumping = false
			_jump_count = 0
	# Aplicamos el vector de velocidad al personaje
	character.velocity = v
