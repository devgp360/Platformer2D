extends AnimatedSprite2D
## Clase que controla la exploción
##
## Elemina la escena despues de exploción, hace daño


@onready var _collision := $Area2D/DamageCollision # Colicionador de la bomba
@onready var _sound := $AudioStreamPlayer # Efecto de sonido


func _on_frame_changed():
	# Si el frame es 1 habilitamos el colicionador
	if frame == 1:
		_collision.disabled = false
	else:
		# deshabilitamos el colicionador
		_collision.disabled = true


func _on_audio_stream_player_finished():
	# eliminamos la escena
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		# Quitamos vidas
		var _move_script = body.get_node("MainCharacterMovement")
		_move_script.hit(10)
		
