class_name TailFollow
extends StaticBody2D

@export var spriteRef: AnimatedSprite2D
@export var collisionShapeRef: CollisionShape2D
var objectToTrack: Node2D
var playerRef: PlayerCharacter

func _ready():
	spriteRef.play("idle")

func SetActive():
	self.show()
	collisionShapeRef.disabled = false

func SetInactive():
	self.hide()
	collisionShapeRef.disabled = true

func SetInfo(tailInfo: Node2D, player: PlayerCharacter):
	objectToTrack = tailInfo
	playerRef = player

func _process(_delta):
	self.global_position = objectToTrack.global_position
	self.global_rotation = objectToTrack.global_rotation
