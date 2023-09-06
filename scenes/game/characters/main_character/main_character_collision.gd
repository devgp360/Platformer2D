extends Node2D

@export var character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not character:
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in character.get_slide_collision_count():
		var collision = character.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.has_method("hint"):
			collider.hint()
