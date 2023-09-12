extends Node
## Script para objeto que hace daño "spike"
##
## Al entrar en contacto con este objeto, el personaje pierda toda la vida


# Escuchamos cuando un "cuerpo" entra en el área de contacto
func _on_area_body_entered(body):
	if body.is_in_group("player"):
		var _move_script = body.get_node("MainCharacterMovement")
		_move_script.hit(10)
