extends Area2D
## Clase que controla animación y configuración de los objetos recolectables
##
## Setea la animación del objeto segun el nombre configurado
## Cambia animación de idle a recolectado, elimina objeto recolectado de la escena


# Nombre del personaje principal
@export var animation = ''

# Definimos el sprite animado de la moneda
@onready var _animated_sprite = $AnimatedSprite2D

# Nombre del personaje principal
var _player_name = 'MainCharacter'


# Función de carga del nodo
func _ready():
	if not animation:
		return
	
	# Cargamos las texturas de animación según el nombre configurado
	var _animation1 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/01.png"
	var _animation2 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/02.png"
	var _animation3 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/03.png"
	var _animation4 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/04.png"
	print(animation)
	# Aplicamos la textura cargada a la animación
	_animated_sprite.sprite_frames.set_frame("idle", 0, load(_animation1))
	_animated_sprite.sprite_frames.set_frame("idle", 1, load(_animation2))
	_animated_sprite.sprite_frames.set_frame("idle", 2, load(_animation3))
	_animated_sprite.sprite_frames.set_frame("idle", 3, load(_animation4))
	
	# Reproducimos la animación idle
	_animated_sprite.play("idle")
	
	
# Función que siempre se llama
func _process(_delta):
	# Validamos si presionamos el boton Escape
	if Input.is_action_pressed("ui_cancel"):
		# Cambiamos la animación
		_animated_sprite.play("taken")


func _physics_process(delta):
	# Obtenemos todos los objetos que collapsan con la moneda
	var bodies = get_overlapping_bodies()
	# Recorremos todos los objetos
	for body in bodies:
		# Validamos si el objeto es nuestro personaje principal
		if body.name == _player_name:
			# Reproducimos la animación de la moneda recogida
			_animated_sprite.play("taken")


func _on_animated_sprite_2d_animation_finished():
	# Eliminamos el objeto recogido de la escena
	queue_free()
