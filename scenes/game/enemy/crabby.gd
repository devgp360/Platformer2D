extends CharacterBody2D
## Clase que controla animación y configuración del Enemigo
##
## Setea la animación y comportamiento del Enemigo 


# Acciones del Enemigo
@export_enum(
	"idle",
	"run",
) var animation: String

# Dirección de movimiento del Enemigo
@export_enum(
	"left",
	"right",
) var moving_direction: String

# Dirección de movimiento del Enemigo
@export var hits_to_die: int = 1

# Dirección de movimiento del Enemigo
@export var is_active: bool = false

# Variable para control de animación y colisiones
@onready var _animation := $EnemyAnimation
@onready var _animation_effect := $EnemyEffect
@onready var _raycast_terrain := $Area2D/RayCastTerrain
@onready var _raycast_wall := $Area2D/RayCastWall
@onready var _raycast_vision_left := $Area2D/RayCastVisionLeft
@onready var _raycast_vision_right := $Area2D/RayCastVisionRight
@onready var _audio_player= $AudioStreamPlayer2D # Reproductor de audios

# Definimos sonidos
var _punch_sound = preload("res://assets/sounds/punch.mp3")
var _male_hurt_sound = preload("res://assets/sounds/male_hurt.mp3")

# Definición de parametros de física
var _gravity = 10
var _speed = 25
# Definición de dirección de movimientos
var _moving_left = true
# Cuantas veces pegaron al personaje principal
var _has_hits = 0
# Copia de objeto que entra a colisión
var _body: Node2D
# Vandera de persecución
var _is_persecuted := false
# Vandera de no detectar colisiones
var _stop_detection := false
# Vandera de no detectar ataques
var _stop_attack := false

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
		_move_character(delta)
		_turn()
	# Si la animación es de idle, aplicamos el movimiento
	elif animation == "idle":
		_move_idle()
	# Si la animación es de persecución, aplicamos la persecución
	if is_active and !_stop_detection:
		_detection()


func _move_character(delta):
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
		_stop_detection = true
		# Atacamos
		_attack()
		# Creamos la copia de objeto
		_body = body


func _on_area_2d_body_exited(body):
	# Estado inicial
	_init_state()


func _turn():
	# Validamos si termino el terreno
	if not _raycast_terrain.is_colliding() or _raycast_wall.is_colliding():
		var _object = _raycast_wall.get_collider()
		if not _object or _object and not _object.is_in_group("player"):
			# Damos la vuelta
			_moving_left = !_moving_left
			scale.x = -scale.x


func _attack():	
	# No atacamos si se seteó la banderita _stop_attack
	if _stop_attack:
		return
		
	if not _body:
		# Esperamos 1 segundos
		await get_tree().create_timer(0).timeout
		_attack()
		
	# Animación de atacar
	_animation.play("attack")


func _init_state():
	# Animación de estado inicial
	_animation.play(animation)
	_animation_effect.play("idle")
	# Limpiamos las variables
	_body = null
	_stop_detection = false

func _on_enemy_animation_frame_changed():
	# Validamos si el frame de animación es 0
	if _animation.frame == 0 and _animation.get_animation() == "attack":
		# Pegamos al personaje
		_animation_effect.play("attack_effect")
		_has_hits += 1
		
		# Quitamos vidas
		var _move_script = _body.get_node("MainCharacterMovement")
		_move_script.hit(5)


func _detection():
	# Obtenemos los colaiders
	var _object1 = _raycast_vision_left.get_collider()
	var _object2 = _raycast_vision_right.get_collider()
	
	# Validamos si la colisión es del lado izquerdo
	if _object1 and _object1.is_in_group("player") and _raycast_vision_left.is_colliding():
		_move(true)
	else:
		_is_persecuted = false
	
	# Validamos si la colisión es del lado derecho
	if _object2 and _object2.is_in_group("player") and _raycast_vision_right.is_colliding():
		_move(false)
	
	# No hay colisiones
	if not _object1 and not _object2 and _animation.get_animation() != "attack":
		_is_persecuted = false
		
		
func _move(_direction):
	# Si ya estamos en acción salimos
	if _is_persecuted or _animation.get_animation() == "attack":
		return
	# Aplicamos la gravidad
	velocity.y += _gravity
	
	# Volteamos al personaje
	if not _direction:
		_moving_left = !_moving_left
		scale.x = -scale.x
	else:
		# Aplicamos la dirección de movimiento
		if _moving_left:
			velocity.x = - _speed
		else:
			velocity.x = _speed

	# Iniciamos el movimiento
	move_and_slide()


func _on_area_2d_area_entered(area):
	# Si estan atacando al enemigo
	if area.is_in_group("hit"):
		# Seteamoas banderita no atacar
		_stop_attack = true
		# Reproducimos sonido
		_audio_player.stream = _punch_sound
		_audio_player.play()
		# Lo matamos y quitamos de la escena
		_animation.play("dead_ground")


func _on_enemy_animation_animation_finished():
	if _animation.animation == "dead_ground":
		queue_free()
	
