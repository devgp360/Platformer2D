extends RigidBody2D
## Clase que controla animación y configuración de la bomba
##
## Setea la animación de la exploción


# Precargamos la escena de la bomba
var _bomb_effect = preload("res://scenes/game/levels/objects/damage_object/bomb/bomb_explotion.tscn")

# Definimos el nodo de animación
@onready var _animation = $BombAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	# Esperamos 3 segundos para la exploción
	await get_tree().create_timer(3).timeout
	# Quitamos la bomba
	_animation.play("idle")
	# Obtenemos la ultima posición
	var _pos = position
	# Obtenemos la escena de exploción
	var bomb_scene = _bomb_effect.instantiate()
	# Ajustamos las posiciónes
	bomb_scene.position = _pos
	bomb_scene.position.y = _pos.y - 20
	# Agregamos el efecto a la escena
	get_parent().add_child(bomb_scene)
	queue_free()
