extends Node2D
## Clase de Inventario 
## 
## Renderización de celdas y objetos de inventario, funcionalidades de agregar nuevos objetos y remover los objetos de inventario ## Revisión de objetos puestos en personaje principal


# Referencia a todas las "cajas", que contienen objetos
var _item_contents = []
# Referencia de todos los nombres de objetos que hay en el inventario
var _item_object_names = []
# Referencia de los items
var _item_objects = []


@onready var canvas = $CanvasLayer # Canvas principal
@onready var animation_player = $CanvasLayer/AnimationPlayer # Player
@onready var grid = $CanvasLayer/Inventory/GridContainer # Grid al cual se añaden elementos


# Función de inicialización
func _ready():
	# Cada "item" recolectado, se agregará dentro de un "contendor"
	# Este contenedor es un "sprite" que tiene una imagen con un "borde" simulando un marco
	# Dentro de este "marco" es donde se agregarán los "items"
	# Para evitar agregar todos los nodos manualmente (6 nodos en este caso), se hizo un ciclo
	#  que los agregará dinámicamente.
	for n in 6:
		var item = load("res://scenes/game/inventory/item_content/item_content.tscn").instantiate()
		grid.add_child(item) # Agregamos el nodo "marco" a un grid
		_item_contents.append(item) # Guardamos la referencia del nodo "marco" en un array


# Función para detectar eventos del teclado o ratón
func _unhandled_input(event):
	# Definimos escenas donde no debe aparecer el inventario
	var scenes = ["Splash", "Init"]
	# Obtenemos el nombre de la escena actual
	var actual_scene = get_tree().get_current_scene().name
	# Si estamos en las escenas definidas no mostramos Inventario
	if scenes.find(actual_scene,0) > -1:
		return
	
	if event.is_action_pressed("wheel_up"):
		# Cuando deslizamos la rueda del ratón hacia arriba, ocultamos el inventario
		animation_player.play_backwards("down")
		await animation_player.animation_finished
		canvas.visible = false
		get_tree().paused = false
	elif event.is_action_pressed("wheel_down"):
		get_tree().paused = true
		# Cuando deslizamos la rueda del ratón hacia abajo, mostramos el inventario
		if canvas.visible == true:
			return
		canvas.visible = true
		animation_player.play("down")
		await animation_player.animation_finished


# Función que añade un item al inventario
# Añadir significa, cargar un elemento (escena) y agregarlo al grid
# El nombre del item, tiene que existir como una escena
# Ejemplo del nombre: blue_potion o green_bottle
func add_item_by_name(_name: String):
	# Si el item ya existe (ya está agregado), se termina la función
	var index = _item_object_names.find(_name)
	if index >= 0:
		# Obtenemos el numero disponible del objeto
		var _num_available = _item_objects[index].get_num()
		# Sumamos uno
		_num_available += 1
		# Actualizamos nuevo número
		var _num = _item_objects[index].set_num(str(_num_available))
		return
	
	# Cargamos el recurso
	var item_to_load = load("res://scenes/game/levels/objects/power_up/power_up_item.tscn")
	
	# Si no existe el recurso, se termina la función
	if not item_to_load:
		return
	
	# Agregamos el item al grid, y guardamos las referencias (para poder eliminarlo si es requerido)
	index = _item_object_names.size()
	var item = item_to_load.instantiate()
	var item_content = _item_contents[index]
	item_content.add_child(item)
	item.set_animation(_name)
	_item_object_names.append(_name);
	_item_objects.append(item)


# Se elimina un elemento del iventario
# Eliminar significa, buscar el "nodo" y eliminarlo del grid principal
# Al eliminar el nodo, todos los demás nodos posteriores, se moverán "hacia atrás"
# para evitar dejar "espacios vacíos"
# Ejemplo del nombre: blue_potion o green_bottle
func remove_item_by_name(_name: String):
	var index = _item_object_names.find(_name)
	if index >= 0:
		var item_content = _item_contents[index] # Nodo que es un "cuadro" contenedor del item recolectado
		var item = _item_objects[index] # Nodo que tiene el item recolectado
		# Ajustamos la cantidad disponible
		var _num_available = _item_objects[index].get_num()
		_num_available -= 1 
		if _num_available > 0:
			var _num = _item_objects[index].set_num(str(_num_available))
			return
		else:
			# Removemos el nodo del item
			item_content.remove_child(item)
			item.queue_free(); # Liberamos memoria (porque no lo vamos a volver a usar)
			
			# Movemos todos los items "hacia atrás" para que ocupen el espacio vacío
			var size = _item_objects.size()
			for n in range(index, size - 1):
				var current_content = _item_contents[n]
				var next_content = _item_contents[n + 1]
				var next_item = _item_objects[n + 1];
				# Removemos el item "next_item" (pero no liberamos memoria)
				next_content.remove_child(next_item);
				# El item removido anteriormente, se reutiliza (agrega) en otro nodo
				current_content.add_child(next_item);
			
			# Quitamos el nombre del listado de "nombres de items"
			_item_object_names.remove_at(index)
			
			# Quitamos el nodo, del listado de nodos tipo item
			_item_objects.remove_at(index)


# Elimina todos los elementos del inventario
func remove_all_items():
	var size = _item_object_names.size()
	for i in size:
		remove_item_by_name(_item_object_names[size - i - 1])


# Retorna un listado de "nombres" de items que están en inventario
func get_item_list_names():
	return _item_object_names


func show_inventory(show: bool):
	canvas.visible = show
	get_tree().paused = show
