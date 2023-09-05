extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $Animation # Nodo AnimationSprite2D
# var anim_idle_with_sword: PackedScene
var asigned = false

var animations_map = {
	"idle_with_sword": "res://scenes/game/characters/main_character/animations/idle_with_sword.tscn",
}

# Función de inicialización del nodo
func _ready():
	animation.play()
	
	# _load_animations()
	# anim_idle_with_sword = load("res://scenes/game/characters/main_character/animations/idle_with_sword.tscn")


# Función para detectar eventos de teclado o ratón
func _unhandled_input(event):
	_flip_sprite(event)


# Girar el sprite al presionar tecla "espacio"
func _flip_sprite(event):
	if event.is_action_pressed("ui_accept"):
		animation.play("idle_with_sword")



func _load_animations():
	for anim_name in animations_map:
		var anim_path = animations_map[anim_name]
		_load_one_animation(anim_name, anim_path)


# Agregamos una animación individual desde otra escena
func _load_one_animation(anim_name, anim_path, default_anim = "default"):
	# Validamos que no exista la animación
	if not animation.sprite_frames.has_animation(anim_name):
		# Cargamos la animación desde la escena
		var scene = load(anim_path)
		var anim_scene = scene.instantiate() as AnimatedSprite2D

		# Creamos la nueva animación
		animation.sprite_frames.add_animation(anim_name)

		# Agregamos todos los frames desde la escena exterior a nuestro nodo de animación
		var count = anim_scene.sprite_frames.get_frame_count(default_anim)
		for index in range(count):
			var frame = anim_scene.sprite_frames.get_frame_texture(default_anim, index)
			animation.sprite_frames.add_frame(anim_name, frame)

		# Agregamos la velocidad a la animación
		var speed = animation.sprite_frames.get_animation_speed(default_anim)
		animation.sprite_frames.set_animation_speed(default_anim, speed)

		# Agregamos la propiedad "loop" a la animación
		var loop = animation.sprite_frames.get_animation_loop(default_anim)
		animation.sprite_frames.set_animation_loop(default_anim, loop)
