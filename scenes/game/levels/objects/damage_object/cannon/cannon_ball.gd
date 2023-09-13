extends RigidBody2D
## Clase que controla animación de la bala
##
## Setea la animación de exploción


# Definimos la animación del cañon
@onready var _ball_animation = $AnimatedSprite2D


func _on_body_entered(body):
	# Validamos si el choque es con el cañon
	if body.is_in_group("cannon"):
		return

	# Detenemos la bala
	self.set_deferred("freeze", true)
	self.set_deferred("sleeping", true)
	self.set_deferred("linear_velocity.x", 0)
	self.set_deferred("linear_velocity.y", 0)
	self.set_deferred("gravity_scale", 0)
	self.collision_mask = 0
	self.collision_layer = 0
	# Reproducimos la animación de la exploción
	_ball_animation.play("explosion")
	if body.is_in_group("player"):
		# Quitamos al personaje principal
		var _move_script = body.get_node("MainCharacterMovement")
		_move_script.hit(10)
