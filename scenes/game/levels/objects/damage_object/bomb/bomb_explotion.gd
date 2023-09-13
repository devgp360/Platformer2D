extends AnimatedSprite2D
## Clase que elemina la escena despues de exploción
##
## Elemina la escena despues de exploción


func _on_animation_finished():
	# eliminamos la escena
	queue_free()
