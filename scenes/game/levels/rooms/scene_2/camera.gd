extends Camera2D

@export var character: CharacterBody2D

var t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not character:
		return
	position = character.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not character:
		return

	return

	var charpos = character.position
	var new_pos = position.lerp(charpos, delta * 1.0)
	new_pos.x = int(new_pos.x)
	new_pos.y = int(new_pos.y)
	position = new_pos
	print("charpos: ", charpos)
	print("position: ", position)
	pass
