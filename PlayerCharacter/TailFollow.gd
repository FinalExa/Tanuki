extends StaticBody2D

var objectToTrack: Node2D

func _process(delta):
	self.position = objectToTrack.global_position
	self.rotation = objectToTrack.global_rotation
