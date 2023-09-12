extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		# Quitamos vidas
		var _move_script = body.get_node("MainCharacterMovement")
		_move_script.hit(100)
