extends Node2D
## Controlador de movimiento y animación de un personaje.
##
## Detecta eventos de teclado para poder mover un personaje por un escenario
## y ajustar animaciones según el movimiento
## Movimiento básica de personaje: https://docs.google.com/document/d/1c9XXznR1KBJSr0jrEWjYIqfFuNGCGP2YASkXsFgEayU/edit


@export var character: CharacterBody2D # Referencia al personaje a mover
@export var main_animation: AnimatedSprite2D # Referencia al sprite del personaje

var gravity = 150 # Gravedad para el personaje
var velocity = 100 # Velocidad de movimiento
var anim_idle_with_sword: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Si no hay un personaje, deshabilitamos la función: _physics_process
	if not character:
		set_physics_process(false)
		
	anim_idle_with_sword = load("res://scenes/game/characters/main_character/animations/idle_with_sword.tscn")


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
		_flip_sprite(false)
	# Cuando se presiona la tecla (flecha derecha), movemos el personaje a la derecha
	elif Input.is_action_pressed("derecha"):
		character.velocity.x = velocity
		_flip_sprite(true)
	elif Input.is_action_pressed("saltar"):
		character.velocity.x = 0
		print("Saltando...")
	# Cuando no presionamos teclas, no hay movimiento
	else:
		character.velocity.x = 0
	# Función de godot para mover y aplicar física y colisiones
	character.move_and_slide()


# Girar el sprite al presionar tecla "espacio"
func _flip_sprite(is_right):
	if not main_animation: # Si no hay un sprite, terminamos la función
		return
		
	if is_right:
		# Si movemos hacia la derecha, no se voltea el sprite
		main_animation.flip_h = false
	else:
		# Si movemos hacia la izquierda, se voltea el sprite (para ver hacia la izquierda)
		main_animation.flip_h = true
