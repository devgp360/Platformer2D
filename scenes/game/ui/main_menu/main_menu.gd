extends Node2D
## Script de menú principal.
##
## Controlará el acceso al menú principal y a las acciones del mismo (iniciar, pantalla completa y volumen de sonidos)
## Menú principal: https://docs.google.com/document/d/17z6OpRIyuTMBbdYGBseTlv9aqLGkM_OUsWnzCGrWyJs/edit?usp=sharing
## Pantalla completa e iniciar juego: https://docs.google.com/document/d/1iXAeyJgSInJz_jI_zl1tHWvQ12DSI-W2FpcLWdxGre8/edit?usp=sharing
## Control de sonidos: https://docs.google.com/document/d/1iF9UeO_rtx2qWtMxjB6LienO-kQPx3blTCgJw-aACx4/edit?usp=sharing


# Nivel inicial que se cargará al presionar "Iniciar" en el menú principal
const PATH_LEVEL_1 = "res://scenes/game/levels/rooms/scene_1/scene_1.tscn"


# Variables para animación de nubes
var _parallax_1_normal = true
var _parallax_2_normal = false
var _started = false # Indica si ya iniciamos el juego (entramos al primer nivel)

# Referencias a nodos de la escena
@onready var _anim_water = $Main/World/Background/AnimWater
@onready var _anim_ship = $Main/World/Ship/Ship
@onready var _anim_flag = $Main/World/Ship/Flag
@onready var _parallax_1 = $Main/ParallaxBackground/Parallax1
@onready var _parallax_2 = $Main/ParallaxBackground/Parallax2
@onready var _button = $Main/CanvasLayer/Options/Init/Button/Button
@onready var _slider_ambient = $Main/CanvasLayer/Options/Sounds/Sliders/Ambient/Slider/SliderAmbient
@onready var _slider_effects = $Main/CanvasLayer/Options/Sounds/Sliders/Effects/Slider/SliderEffects
@onready var _main = $Main
@onready var _game_controls = $Main/GameControls


# Función de inicialización
func _ready():
	# Al cargar hacemos esta escena invisible
	visible = true
	# Impide que esta escena se ponga en pausa
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#_toggle_show()
	HealthDashboard.visible = false
	# Iniciamoa con las animaciones
	_anim_water.play()
	_anim_ship.play()
	_anim_flag.play()
	_parallax_1.play("parallax1")
	_parallax_2.play_backwards("parallax1")
	# Iniciar volumen de sonidos en base al valor de los "sliders"
	_on_slider_ambient_value_changed(_slider_ambient.value)
	_on_slider_effects_value_changed(_slider_effects.value)
	_toggle_show()
	# Ocultamos el canvas de los controles
	_game_controls.visible = false

# Detecta eventos de teclado y ratón
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and _started:
		# Al presionar "scape" mostramos/ocultamos el menú (solo si hemos "iniciado")
		_toggle_show()


# Se ejecuta cuando finaliza la animación de las nubes #1
func _on_parallax_1_animation_finished(_anim_name):
	# Hace animación de izquierda a derecha indefinidamente
	if _parallax_1_normal:
		_parallax_1.play_backwards("parallax1")
		_parallax_1_normal = false
	else:
		_parallax_1.play("parallax1")
		_parallax_1_normal = true


# Se ejecuta cuando finaliza la animación de las nubes #2
func _on_parallax_2_animation_finished(_anim_name):
	# Hace animación de izquierda a derecha indefinidamente
	if _parallax_2_normal:
		_parallax_2.play_backwards("parallax1")
		_parallax_2_normal = false
	else:
		_parallax_2.play("parallax1")
		_parallax_2_normal = true


# Función que mostrará u ocultará el menú principal, desmontando nodos, pausando y controlando
# cámaras de los niveles
func _toggle_show():
	visible = not visible # Mostramos/Ocultamos el menu
	HealthDashboard.visible = not visible # Mostramos/Ocultamos el tablero de salud
	# Agregar o remover el nodo principal del menú principal
	if visible:
		self.add_child(_main)
	else:
		self.remove_child(_main)
	
	get_tree().paused = visible # Si estamos en el menú, pausamos
	
	# Buscamos el nodo principal del nivel actual "Main"
	var main_node = get_tree().get_root().get_node("Main")
	if main_node:
		# Buscamos la cámara del nivel actual "Camera2D"
		var camera = main_node.find_child("Camera2D")
		if camera:
			# La cámara la habilitamos o deshabilitamos
			camera.enabled = not visible
	# Si ya hemos iniciado, cambiamos el texto del botón a "Continuar"
	if _started:
		_button.text = "Continuar"


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
		#_toggle_show()


# Cuando cambia el slider de sonido de ambiente ajustamos el volumne de ambiente
func _on_slider_ambient_value_changed(value):
	var bus = AudioServer.get_bus_index("Ambient")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


# Cuando cambia el slider de sonido de efectos ajustamos el volumne de los efectos
func _on_slider_effects_value_changed(value):
	var bus = AudioServer.get_bus_index("Effects")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


# Función para poder mostrar/ocultar el menú
func show_menu(_show: bool):
	if _show:
		if not visible:
			_toggle_show()
	else:
		if visible:
			_toggle_show()


# Función para resetear el juego
func restart():
	#_toggle_show()
	_started = false
	_button.text = "Iniciar"


# Mostramos/Ocultamos la pantalla de controles
func _on_show_controls_pressed():
	_game_controls.visible = not _game_controls.visible


# Cerramos la pantalla de controles
func _on_close_controls_pressed():
	_game_controls.visible = false
