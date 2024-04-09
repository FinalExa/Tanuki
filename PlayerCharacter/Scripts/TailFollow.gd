class_name TailFollow
extends StaticBody2D

@export var spriteRef: AnimatedSprite2D
var objectToTrack: Node2D
var playerRef: PlayerCharacter

func _ready():
	spriteRef.play("idle")

func _process(_delta):
	self.position = objectToTrack.global_position
	self.rotation = objectToTrack.global_rotation
