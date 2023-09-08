extends Node2D
## Controlador de colisiones.
##
## Detecta eventos de colisión

@export var character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not character:
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Revisamos todas las colisiones
	for i in character.get_slide_collision_count():
		# Obtenemos la colisión
		var collision = character.get_slide_collision(i)
		# Obtenemos el collider
		var collider = collision.get_collider()
		# Validamos si existe el metodo hit
		if collider and collider.has_method("hit"):
			collider.hit()
