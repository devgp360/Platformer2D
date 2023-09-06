extends RigidBody2D
## Clase que controla animación y configuración de los objetos que reciben daño
##
## Setea la animación del objeto segun el nombre configurado
## Cambia animación de idle a destruido, elimina objeto destruible de la escena


# Definimos el sprite animado del objeto
@onready var _animated_sprite = $AnimatedSprite2D
# Definimos la escena de destrucción del objeto
@onready var _box_destroyed = $BoxDestroyed
# Vandera de hacer animación
var _do_animation = false

	
# Función de carga del nodo
func _ready():
	# Reproducimos la animación idle
	_animated_sprite.play("idle")
	# No mostramos la animación de destrucción
	_box_destroyed.get_parent().remove_child(_box_destroyed)
	

func _on_animated_sprite_2d_animation_finished():
	# Validamos si la animación es de pegar
	if _animated_sprite.get_animation() == 'hit':
		# Quitamos el sprite de la caja
		_animated_sprite.visible = false
		# Agregamos la animación de destrución
		self.add_child(_box_destroyed)
		# Esperamos 3 segundos
		await get_tree().create_timer(3).timeout
		# Eliminamos el objeto
		queue_free()
					
	
func do_animation():
	# Reproducir la animación pegar
	_animated_sprite.play("hit")


func hint():
	# Validamos si estamos reproduciendo la animación
	if not _do_animation:
		# Seteamos que ya estamos reproduciendo la animación
		_do_animation = true
		# Reproducimos la animación
		do_animation()
