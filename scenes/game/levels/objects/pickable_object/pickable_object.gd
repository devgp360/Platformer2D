extends Area2D
## Clase que controla animación y configuración de los objetos recolectables
##
## Setea la animación del objeto segun el nombre configurado
## Cambia animación de idle a recolectado, elimina objeto recolectado de la escena


# Nombre del personaje principal
@export_enum(
	"blue_diamond",
	"green_diamond", 
	"red_diamond",
	"gold_coin",
	"silver_coin",
) var animation: String

# Definimos el sprite animado de la moneda
@onready var _animated_sprite = $AnimatedSprite2D


# Función de carga del nodo
func _ready():
	if not animation:
		return
	
	# Cargamos las texturas de animación según el nombre configurado
	var _animation1 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/01.png"
	var _animation2 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/02.png"
	var _animation3 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/03.png"
	var _animation4 = "res://assets/sprites/treasure_hunters/pirate_treasure/sprites/" + animation + "/04.png"

	# Aplicamos la textura cargada a la animación
	_animated_sprite.sprite_frames.set_frame("idle", 0, load(_animation1))
	_animated_sprite.sprite_frames.set_frame("idle", 1, load(_animation2))
	_animated_sprite.sprite_frames.set_frame("idle", 2, load(_animation3))
	_animated_sprite.sprite_frames.set_frame("idle", 3, load(_animation4))
	
	# Reproducimos la animación idle
	_animated_sprite.play("idle")
	

func _on_animated_sprite_2d_animation_finished():
	# Eliminamos el objeto recogido de la escena
	queue_free()
	
	
func do_animation():
	# Validamos si la animación es de moneda
	if animation == "gold_coin" or animation == "silver_coin":
		# Reproducimos la animación de la moneda
		_animated_sprite.play("coin_taken")
	else:
		# Reproducimos la animación del diamante
		_animated_sprite.play("diamond_taken")


func _on_area_entered(area):
	# Validamos que la colisión es con el personaje principal 
	if area.is_in_group("player"):
		# Reproducimos la animación de la moneda recogida
		do_animation()
