extends CharacterBody2D
## Clase que controla el comportamiento de NPC
##
## Controla los dialogos con el personaje principal, escucha coliciones


# Area de contacto, para mostrar el diálogo
var _npc_dialogue_area: Node2D
# Determina el estado del diálogo (activo o inactivo)
var _dialog_active = false

@onready var _collision = $CollisionShape2D
@onready var _collisionListen = $Area2DListen/CollisionShape2D
@onready var _animation = $Npc

# Función de inicialización
func _ready():
	_npc_dialogue_area = find_child("NpcDialogueArea") # Buscamos el area de diálogo


func _physics_process(delta):
	# Agregamos la velocidad
	velocity.y += 1000 * delta
	move_and_slide() # Agregamos kinematica
	if is_on_floor():
		# Apagamos la física
		set_physics_process(false)
	

# DOCUMENTACIÓN (señales): https://docs.google.com/document/d/1bbroyXp11L4_FpHpqA-RckvFLRv3UOE-hmQdwtx27eo/edit?usp=drive_link
# Se usa para poder "escuchar" cuando el diálgo finaliza
func on_dialogue_ended(fn):
	if _npc_dialogue_area:
		_npc_dialogue_area.on_dialogue_ended(fn)


# Se usa para poder "escuchar" cuando se selecciona una respuesta en el diálogo
func on_response_selected(fn):
	if _npc_dialogue_area:
		_npc_dialogue_area.on_response_selected(fn)


# Función que deshabilita las colisiones del NPC y también la física
func disabled_collision(disabled: bool):
	set_physics_process(not disabled)
	_collision.disabled = disabled


# Función para rotar la animación del NPC
func flip_h(flip: bool):
	_animation.flip_h = flip


# Seteamos un nuevo diálogo y lo mostramos
func set_and_show_dialogue(resource: DialogueResource):
	if _npc_dialogue_area:
		_npc_dialogue_area.set_and_show_dialogue(resource)


# Seteamos un nuevo diálogo
func set_dialogue(resource: DialogueResource):
	if _npc_dialogue_area:
		_npc_dialogue_area.set_dialogue(resource)


# Retornamos el manejador de diálogos que esté activo
func get_dialogue_manager():
	if _npc_dialogue_area:
		return _npc_dialogue_area.dialogue_manager


# DOCUMENTACIÓN (áreas de colisión): https://docs.google.com/document/d/1FFAJSrAdE5xyY_iqUteeajHKY3tAIX5Q4TokM2KA3fw/edit?usp=drive_link
# Función cuando un área entra en contacto con el NPC. _area: es el área que hace contacto
func _on_area_2d_listen_area_exited(area):
	# Seteamos variable del dialogo a false al abandonar el area
	_dialog_active = false
