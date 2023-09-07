extends CharacterBody2D
## Clase que controla animación y configuración del NPC
##
## Setea la animación y comportamiento del NPC 


# Acciones del NPC
@export_enum(
	"idle",
	"run", 
	"active", 
) var animation: String

# Dirección de movimiento del NPC
@export_enum(
	"left",
	"right", 
) var moving_direction: String

# Dirección de movimiento del NPC
@export var hits_to_die: int = 1

# Variable para control de animación y colisiones
@onready var _animation := $NpcAnimation
@onready var _animation_effect := $NpcEffect
@onready var _raycast_terrain := $Area2D/RayCastTerrain

# Definición de parametros de física
var _gravity = 10
var _speed = 25
# Definición de dirección de movimientos
var _moving_left = true
# Cuantas veces pegaron al personaje principal
var _has_hits = 0
var _body: Node2D


# Función de inicialización
func _ready():
	# Seteamos la direccion de movimiento
	if moving_direction == 'right':
		_moving_left = false
		scale.x = -scale.x
	# Si no seteamos la animación ponemos por defecto la animación idle
	if not animation:
		animation = "idle"
	# Iniciamos la animación
	_init_state()


func _physics_process(delta):
	# Si la animación es de correr, aplicamos el movimiento
	if animation == "run":
		_move_character()
		_turn()
	elif animation == "idle":
		_move_idle()


func _move_character():
	# Aplicamos la gravidad
	velocity.y += _gravity 
	
	# Aplicamos la dirección de movimiento
	if _moving_left:
		velocity.x = - _speed 
	else:
		velocity.x = _speed 
	# Iniciamos el movimiento
	move_and_slide()
	

func _move_idle():
	# Aplicamos la gravidad
	velocity.y += _gravity 
	# Aplicamos la dirección de movimiento
	velocity.x = 0
	# Iniciamos el movimiento
	move_and_slide()


func _on_area_2d_body_entered(body):
	# Validamos si la colición es con el personaje principal
	if body.is_in_group("player"):
		# Atacamos
		_atack()
		_body = body


func _on_area_2d_body_exited(body):
	# Estado inicial
	_init_state()


func _turn():
	# Validamos si termino el terreno
	if not _raycast_terrain.is_colliding():
		# Damos la vuelta
		_moving_left = !_moving_left
		scale.x = -scale.x


func _atack():
	# Animación de atacar
	_animation.play("attack")


func _init_state():
	# Animación de estado inicial
	_animation.play(animation)
	_animation_effect.play("idle")
	_body = null


func _on_npc_animation_frame_changed():
	# Validamos si el frame de animación es 0
	if _animation.frame == 0 and _animation.get_animation() == "attack":
		_animation_effect.play("attack_effect")
		_has_hits += 1
		if _has_hits >= hits_to_die and _body:
			var _move_script = _body.get_node("MainCharacterMovement")
			if _move_script:
				_move_script.die()
