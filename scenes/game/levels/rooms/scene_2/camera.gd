extends Camera2D

var _direction = 'right'
var _step = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.position.x < 0 and _direction == 'left') || (
		self.position.x < 1500 and _direction == 'right'
	):
		_direction = 'right'
	elif self.position.x > 1500 and _direction == 'right':
		_direction = 'left'
		
	if _direction == 'right':
		self.position.x = self.position.x + _step
	else:
		self.position.x = self.position.x - _step
