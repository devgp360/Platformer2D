extends CharacterBody2D
## Clase que controla animación y configuración del NPC
##
## Setea la animación y comportamiento del NPC 


# Acciones del NPC
@export_enum(
	"idle",
	"run", 
) var animation: String

# Variable para control de animación
@onready var _animation := $NpcAnimation

var _gravity = 10
var _speed = 25
var _velocity = Vector2(0,0)


# Función de inicialización
func _ready():
	if not animation:
		return
	_animation.play(animation)
	
	
func _process(delta):
	_move_character()
	
	
func _move_character():
	_velocity.y += _gravity 
	_velocity.x += - _speed 
	_velocity = move_and_slide()
