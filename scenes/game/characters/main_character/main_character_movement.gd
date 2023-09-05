extends Node2D
## Controlador de movimiento y animación de un personaje.
##
## Detecta eventos de teclado para poder mover un personaje por un escenario
## y ajustar animaciones según el movimiento
## Movimiento básica de personaje: https://docs.google.com/document/d/1c9XXznR1KBJSr0jrEWjYIqfFuNGCGP2YASkXsFgEayU/edit


@export var character: CharacterBody2D # Referencia al personaje a mover
@export var main_animation: AnimatedSprite2D # Referencia al sprite del personaje

var movements = {
	IDLE = "default",
	IDLE_WITH_SWORD = "idle_with_sword",
	LEFT_WITH_SWORD = "left_with_sword",
	RIGHT_WITH_SWORD = "run_with_sword",
	JUMP_WITH_SWORD = "jump_with_sword",
}
var gravity = 150 # Gravedad para el personaje
var velocity = 100 # Velocidad de movimiento
var current_movement = movements.IDLE # Variable de movimiento


# Called when the node enters the scene tree for the first time.
func _ready():
	main_animation.play(current_movement)
	# Si no hay un personaje, deshabilitamos la función: _physics_process
	if not character:
		set_physics_process(false)
	

# Función de ejecución de físicas
func _physics_process(_delta):
	_move()


# Función de movimiento general del personaje
func _move():
	# Aplicamos una constante de gravedad al valor "Y" de la velocidad del personaje
	character.velocity.y = gravity
	
	# Cuando se presiona la tecla (flecha izquierda), movemos el personaje a la izquierda
	if Input.is_action_pressed("izquierda"):
		character.velocity.x = -velocity
		current_movement = movements.LEFT_WITH_SWORD
	# Cuando se presiona la tecla (flecha derecha), movemos el personaje a la derecha
	elif Input.is_action_pressed("derecha"):
		character.velocity.x = velocity
		current_movement = movements.RIGHT_WITH_SWORD
	# Cuando se presiona la tecla (espacio), hacemos animación de salto
	elif Input.is_action_pressed("saltar"):
		character.velocity.x = 0
		current_movement = movements.JUMP_WITH_SWORD
	# Cuando no presionamos teclas, no hay movimiento
	else:
		character.velocity.x = 0
		current_movement = movements.IDLE
	
	_set_animation()
	# Función de godot para mover y aplicar física y colisiones
	character.move_and_slide()


# Controla la animación según el movimiento del personaje
func _set_animation():
	if current_movement == movements.RIGHT_WITH_SWORD:
		# Movimiento hacia la derecha (animación "correr" no volteada)
		main_animation.play(movements.RIGHT_WITH_SWORD)
		main_animation.flip_h = false
	elif current_movement == movements.LEFT_WITH_SWORD:
		# Movimiento hacia la izquierda (animación "correr" volteada)
		main_animation.play(movements.RIGHT_WITH_SWORD)
		main_animation.flip_h = true
	elif current_movement == movements.JUMP_WITH_SWORD:
		# Movimiento de salto (animación de "salto")
		main_animation.play(movements.JUMP_WITH_SWORD)
	else:
		# Movimiento por defecto (animación de "reposo")
		main_animation.play(movements.IDLE_WITH_SWORD)
