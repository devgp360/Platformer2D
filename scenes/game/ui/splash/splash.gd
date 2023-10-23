extends Node2D
## Clase que controla la escena principal (Splash) 
## 
## Cambia la escena actual por mapa global del juego, hace animación de logos, dueños del juego 


@onready var AnimationPlayerGP360: AnimationPlayer = $AnimationPlayerGP360
@onready var AnimationPlayerEndless: AnimationPlayer = $AnimationPlayerEndless
@onready var AnimationPixelFrog: AnimationPlayer = $AnimationPixelFrog

# Ruta a la escena a cargar cuando finalice el "splash"
var _path_map_scene = "res://scenes/game/levels/rooms/init/init.tscn"


func _ready():
	# Escondemos la escena del menu
	HealthDashboard.visible = false
	# Mostramos el logo de Endless
	AnimationPlayerEndless.play("do_splash")


# Escuchamos el teclado
func _input(event):
	# Escuchamos si se preciona algun boton
	if event is InputEventKey:
		# Llamamos el la función de cambio de escena
		_go_title_screen()


# Cuando termina la animación
func _on_animation_player_animation_finished(_anim_name):
	# Mostramos el logo de Pixel Frog
	AnimationPixelFrog.play("do_splash")


# Redirect a la escena de Mapa
func _go_title_screen():
	# Pasamos a la escena de Menú principal
	SceneTransition.change_scene(_path_map_scene)


func _on_animation_player_endless_animation_finished(anim_name):
	# Mostramos el logo de GP360
	AnimationPlayerGP360.play("do_splash")


func _on_animation_pixel_frog_animation_finished(anim_name):
	# Llamamos el la funcion de cambio de escena
	_go_title_screen()
