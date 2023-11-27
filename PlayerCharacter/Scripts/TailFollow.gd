class_name TailFollow
extends StaticBody2D

var objectToTrack: Node2D
var playerRef: PlayerCharacter

func _process(_delta):
	self.position = objectToTrack.global_position
	self.rotation = objectToTrack.global_rotation
