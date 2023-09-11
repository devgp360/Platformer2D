extends Node2D
## Clase que controla la escena principal (Splash) 
## 
## Cambia la escena actual por mapa global del juego, hace animación de logos, dueños del juego 

@onready var anim: AnimationPlayer = $AnimationPlayer

# Ruta a la escena a cargar cuando finalice el "splash"
var _path_map_scene = "res://scenes/game/ui/main_menu/main_menu.tscn"


func _ready():
	# Escondemos la escena del menu
	MainMenu._toggle_show()


# Escuchamos el teclado
func _input(event):
	# Escuchamos si se preciona algun boton
	if event is InputEventKey:
		# Llamamos el la función de cambio de escena
		_go_title_screen()


# Cuando termina la animación
func _on_animation_player_animation_finished(_anim_name):
	# Llamamos el la funcion de cambio de escena
	_go_title_screen()


# Redirect a la escena de Mapa
func _go_title_screen():
	# Pasamos a la escena de Menú principal
	get_tree().change_scene_to_file(_path_map_scene)
