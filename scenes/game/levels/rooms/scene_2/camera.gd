extends Camera2D
## Controlador de movimiento y animación de un personaje.
##
## Detecta eventos de teclado para poder mover un personaje por un escenario
## y ajustar animaciones según el movimiento
## Movimiento básica de personaje: https://docs.google.com/document/d/1c9XXznR1KBJSr0jrEWjYIqfFuNGCGP2YASkXsFgEayU/edit



@export var character: CharacterBody2D


# Función de inicialización
func _ready():
	if not character:
		set_physics_process(false)
		return
		
	position = character.position

func _physics_process(delta):
	var charpos = character.position
	var new_pos = position.lerp(charpos, delta * 2.0)
	
	new_pos.x = int(new_pos.x)
	new_pos.y = int(new_pos.y)
	
	position = new_pos
