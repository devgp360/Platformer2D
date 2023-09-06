extends CharacterBody2D
## Clase que controla animación y configuración del NPC
##
## Setea la animación y comportamiento del NPC 


# Variable para control de animación
@onready var anim := $NpcAnimation


# Función de inicialización
func _ready():
	anim.play("idle")
