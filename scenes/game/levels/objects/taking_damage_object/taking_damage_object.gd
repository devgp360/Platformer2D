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
		# Quitamos la colisión
		self.set_deferred("collision_layer", 2)
		# Agregamos la animación de destrución
		self.add_child(_box_destroyed)
		# Esperamos 3 segundos
		await get_tree().create_timer(3).timeout
		# Eliminamos el objeto
		queue_free()
					
	
func do_animation():
	# Reproducir la animación pegar
	_animated_sprite.play("hit")


func _on_area_2d_area_entered(area):
	# Validamos si hay colisión
	if area.is_in_group("hit"):
		_collided(area)
	elif area.is_in_group("die"):
		_collided(area)


func _collided(area):
	# Seteamos la dirección de destrucción
	if global_position.x < area.global_position.x:
		set_direction(false)
	else:
		set_direction(true)
		
	# Validamos si estamos reproduciendo la animación
	if not _do_animation:
		# Seteamos que ya estamos reproduciendo la animación
		_do_animation = true
		# Reproducimos la animación
		do_animation()
		
		
func set_direction(left):
	# Recorremos todos los hijos de la escena
	for child in _box_destroyed.get_children():
		# Gardamos la velocidad definida
		var speed = abs(child.linear_velocity.x)
		if left:
			# Aplicamos la velocidad positiva
			child.linear_velocity.x = speed
		else:
			# Aplicamos la velocidad negativa
			child.linear_velocity.x = - speed
