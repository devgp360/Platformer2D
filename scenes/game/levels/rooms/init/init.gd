extends Node2D
## Clase que controla la escena inicial
## 
## Muestra el menú principal apagado desde la escena Splash


# Called when the node enters the scene tree for the first time.
func _ready():
	# Mostramos el menú principal
	MainMenu.show_menu(true)

