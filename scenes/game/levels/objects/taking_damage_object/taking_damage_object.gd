extends Area2D
## Clase que controla animación y configuración de los objetos que reciben daño
##
## Setea la animación del objeto segun el nombre configurado
## Cambia animación de idle a destruido, elimina objeto destruible de la escena

# Definimos el sprite animado del objeto
@onready var _animated_sprite = $AnimatedSprite2D
# Definimos la escena de destrucción del objeto
@onready var _box_destroyed = $BoxDestroyed

# Ruta de sprites de animación
var _base_link = "res://assets/sprites/treasure_hunters/merchant_ship/sprites/"
	
# Función de carga del nodo
func _ready():
	# Cargamos las texturas de animación según el nombre configurado
	var _animation = _base_link + "box/idle" + "/1.png"
	# Aplicamos la textura cargada a la animación
	_animated_sprite.sprite_frames.set_frame("idle", 0, load(_animation))
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
	# Cargamos las imágenes de animación pegar
	var _animationHit2 = _base_link + "box/hit" + "/2.png"
	var _animationHit3 = _base_link + "box/hit" + "/3.png"
	var _animationHit4 = _base_link + "box/hit" + "/4.png"
	
	# Aplicamos la textura cargada a la animación
	_animated_sprite.sprite_frames.set_frame("hit", 0, load(_animationHit2))
	_animated_sprite.sprite_frames.set_frame("hit", 1, load(_animationHit3))
	_animated_sprite.sprite_frames.set_frame("hit", 2, load(_animationHit4))
	# Reproducimos la animación
	_animated_sprite.play("hit")


func _on_area_entered(area):
	# Validamos si la colisión es de personaje principal
	if area.is_in_group("player"):
		# Reproducimos la animación de la moneda recogida
		do_animation()
