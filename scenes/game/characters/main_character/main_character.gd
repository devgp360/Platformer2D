extends CharacterBody2D

@onready var animation = $Animation # Nodo AnimationSprite2D


# Función de inicialización del nodo
func _ready():
	animation.play()


# Función que se ejecuta en cada frame: delta: es el tiempo transcurrido desde el frame anterior
func _process(delta):
	pass


# Función para detectar eventos de teclado o ratón
func _unhandled_input(event):
	_flip_sprite(event)


# Girar el sprite al presionar tecla "espacio"
func _flip_sprite(event):
	if event.is_action_pressed("ui_accept"):
		animation.flip_h = not animation.flip_h
