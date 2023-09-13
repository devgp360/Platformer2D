extends Node2D

@onready var npc = $NPC/BigGuy


# Called when the node enters the scene tree for the first time.
func _ready():
	npc.disabled_collision(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
