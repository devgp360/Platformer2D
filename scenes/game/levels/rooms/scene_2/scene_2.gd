extends Node2D


# Función para detectar eventos de teclado o ratón
func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		# Cuando presionemos la "flecha arriba" cambiamos de escena
		var scene = "res://scenes/game/levels/rooms/scene_1/scene_1.tscn"
		SceneTransition.change_scene(scene)
