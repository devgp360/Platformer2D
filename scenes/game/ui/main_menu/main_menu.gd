extends Node2D
## Script de menú principal.
##
## Controlará el acceso al menú principal y a las acciones del mismo (iniciar, pantalla completa y volumen de sonidos)
## Menú principal: https://docs.google.com/document/d/17z6OpRIyuTMBbdYGBseTlv9aqLGkM_OUsWnzCGrWyJs/edit?usp=sharing


const PATH_LEVEL_1 = "res://scenes/game/levels/rooms/scene_2/scene_2.tscn"

# Variables para animación de nubes
var _parallax_1_normal = true
var _parallax_2_normal = false
var _started = false # Indica si ya iniciamos el juego (entramos al primer nivel)

# Referencias a nodos de la escena
@onready var grind_sound = $Main/CanvasLayer/Options/Sounds/GridSound
@onready var anim_water = $Main/World/Background/AnimWater
@onready var anim_ship = $Main/World/Ship/Ship
@onready var anim_flag = $Main/World/Ship/Flag
@onready var parallax_1 = $Main/ParallaxBackground/Parallax1
@onready var parallax_2 = $Main/ParallaxBackground/Parallax2
@onready var button = $Main/CanvasLayer/Options/Init/Button/Button
@onready var main = $Main


# Función de inicialización
func _ready():
	# Al cargar hacemos esta escena invisible
	visible = true
	# Impide que esta escena se ponga en pausa
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#_toggle_show()
	HealthDashboard.visible = false
	# Iniciamoa con las animaciones
	anim_water.play()
	anim_ship.play()
	anim_flag.play()
	parallax_1.play("parallax1")
	parallax_2.play_backwards("parallax1")


# Detecta eventos de teclado y ratón
func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		_toggle_show() # Al presionar "scape" mostramos/ocultamos el menú


# Se ejecuta cuando finaliza la animación de las nubes #1
func _on_parallax_1_animation_finished(_anim_name):
	# Hace animación de izquierda a derecha indefinidamente
	if _parallax_1_normal:
		parallax_1.play_backwards("parallax1")
		_parallax_1_normal = false
	else:
		parallax_1.play("parallax1")
		_parallax_1_normal = true


# Se ejecuta cuando finaliza la animación de las nubes #2
func _on_parallax_2_animation_finished(_anim_name):
	# Hace animación de izquierda a derecha indefinidamente
	if _parallax_2_normal:
		parallax_2.play_backwards("parallax1")
		_parallax_2_normal = false
	else:
		parallax_2.play("parallax1")
		_parallax_2_normal = true


# Función que mostrará u ocultará el menú principal, desmontando nodos, pausando y controlando
# cámaras de los niveles
func _toggle_show():
	visible = not visible # Mostramos/Ocultamos el menu
	HealthDashboard.visible = not visible # Mostramos/Ocultamos el tablero de salud
	
	if visible:
		self.add_child(main)
	else:
		self.remove_child(main)
		
	# Buscamos el nodo principal del nivel actual "Main"
	var main_node = get_tree().get_root().get_node("Main")
	if main_node:
		# Buscamos la cámara del nivel actual "Camera2D"
		var camera = main_node.find_child("Camera2D")
		get_tree().paused = visible # Si estamos en el menú, pausamos
		if camera:
			# La cámara la habilitamos o deshabilitamos
			camera.enabled = not visible
	# Si ya hemos iniciado, cambiamos el texto del botón a "Continuar"
	if _started:
		button.text = "Continuar"


# Evento de nodo "CheckButton" para hacer pantalla completa o en modo ventana
func _on_check_button_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


# Se ejecuta al presionar botón "iniciar"
func _on_button_pressed():
	if _started:
		# Si ya tenemos iniciado el juego, solo ocultamos el menú
		_toggle_show()
	else:
		# Si no hemos iniciado, cargamos nivel 1 y cambiamos título de boton
		SceneTransition.change_scene(PATH_LEVEL_1)
		_started = true


# Función para poder mostrar/ocultar el menú
func show_menu(_show: bool):
	visible = not _show
	_toggle_show()
