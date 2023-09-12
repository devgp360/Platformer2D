extends RigidBody2D
## Clase que controla animación y configuración del objeto cañón
##
## Setea la animación del objeto 
## Cambia animación de idle a disparado, elimina la bala de la escena


# Definimos la escena de destrucción del objeto
@onready var _cannon_animation = $AnimatedSprite2D
# Definimos el sprite animado de efectos
@onready var _animated_sprite_effects = $AnimatedSprite2DEffects
# Definimos la bala de cañón
var new_ball: RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Disparamos
	fire()
	
	
func fire():
	# Reproducimos la animación de disparo
	_cannon_animation.play("fire")


func _on_animated_sprite_2d_frame_changed():
	# Validamos si el frame de animación es 3
	if _cannon_animation.frame == 3:
		# Cargamos la escena de bala
		var ball = "scenes/game/levels/objects/damage_object/cannon/cannon_ball.tscn"
		new_ball = load(ball).instantiate()
		new_ball.position.x = -20
		# Agregamos la bala a la escena
		self.add_child(new_ball)
		# Agregamos la animación de humo
		_animated_sprite_effects.play("fire_effect")


func _on_animated_sprite_2d_animation_finished():
	# Validamos si la animación es de fuego
	if _cannon_animation.get_animation() == 'fire':
		# Esperamos un segundo
		await get_tree().create_timer(1).timeout
		# Eliminamos la bala
		new_ball.queue_free()
		# Disparamos otra vez
		fire()
		
