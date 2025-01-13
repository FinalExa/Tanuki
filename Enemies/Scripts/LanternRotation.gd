extends Sprite2D

var startRotation: float

func _ready():
	startRotation = global_rotation_degrees

func _physics_process(_delta):
	self.global_rotation_degrees = startRotation
