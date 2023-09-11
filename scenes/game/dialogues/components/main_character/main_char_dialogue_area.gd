extends Node2D
## Clase que controla los eventos de diálogos de parte de personaje principal 
## 
## Se controlan los eventos de colisión de personaje principal, funciones que levantan diálogos 


# DOCUMENTACIÓN ¿QUÉ SON LAS SEÑALES EN GDSCRIPT?: https://docs.google.com/document/d/1bbroyXp11L4_FpHpqA-RckvFLRv3UOE-hmQdwtx27eo
# DOCUMENTACIÓN (diálogos entre personajes): https://docs.google.com/document/d/1LO1XeDq58IKrXyzbgeStl16No89CeKeArLRQyjY8oVk/edit?usp=drive_link

# Definicion de la señal del dialogo (al emitir esta señal, se mostrará el diálogo)
signal talk()

# Conexión del nodo Area2D
@export var external_area2d: Area2D
# Puedes leer más sobre nodos en éste documento: https://docs.google.com/document/d/1AiO1cmB31FSQ28me-Rb15EQni8Pyomc1Vgdm1ljL3hc

# Definición del nodo del NPC
var _npc_dialogue_node: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# DOCUMENTACIÓN (señales): https://docs.google.com/document/d/1bbroyXp11L4_FpHpqA-RckvFLRv3UOE-hmQdwtx27eo/edit?usp=drive_link
	# Conexión del area de entrada al dialogo
	external_area2d.area_entered.connect(_area_entered)
	# Conexión del area de salida al dialogo
	external_area2d.area_exited.connect(_area_exited)

	# Inicio del dialogo
	talk.connect(_show_dialogue)


# Mostramos el diálogo
func _show_dialogue():
	# Validación de que hay que mostrar el dialogo
	if _npc_dialogue_node:
		# Levantar el diálogo
		_npc_dialogue_node.emit_signal("talk")


# DOCUMENTACIÓN (áreas de colisión): https://docs.google.com/document/d/1FFAJSrAdE5xyY_iqUteeajHKY3tAIX5Q4TokM2KA3fw/edit?usp=drive_link
# Cuando puntero sale del área de diálogo
func _area_exited(_area):
	# Resetar el dialogo
	_npc_dialogue_node = null


# Cuando puntero entra al área de diálogo
func _area_entered(area):
	# En el caso que entremos al área de un NPC que tenga diálogos
	var child = area.find_child("NpcDialogueArea")

	# Si se encuentra el NPC con diálogo
	if child:
		# Asignamos el diálogo encontrado al nodo del NPC
		_npc_dialogue_node = child
		# Emitimos la señal para mostrar el diálogo
		_npc_dialogue_node.emit_signal("talk")
