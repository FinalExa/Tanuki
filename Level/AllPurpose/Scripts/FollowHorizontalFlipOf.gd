extends AnimatedSprite2D

@export var objectToFollow: AnimatedSprite2D

func _process(_delta):
	if (self.flip_h != objectToFollow.flip_h):
		self.flip_h = objectToFollow.flip_h
