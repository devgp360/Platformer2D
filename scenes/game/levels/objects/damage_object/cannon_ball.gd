extends RigidBody2D
## Clase que controla animación de la bala
##
## Setea la animación de exploción


# Definimos la escena de destrucción del objeto
@onready var _ball_animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	# Reproducimos la animación de la moneda recogida
	self.set_deferred("freeze", true)
	self.set_deferred("sleeping", true)
	self.set_deferred("linear_velocity.x", 0)
	self.set_deferred("linear_velocity.y", 0)
	self.set_deferred("gravity_scale", 0)
	_ball_animation.play("explosion")
	if body.is_in_group("player"):
		print('murio')
