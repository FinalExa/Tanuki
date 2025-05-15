class_name DoorOpenClose
extends Node2D

@export var startOpen: bool
@export var centralCollider: CollisionShape2D
@export var closedSprite: Sprite2D
@export var openSprite: Sprite2D

func _ready():
	if (startOpen):
		OpenDoor()
	else:
		CloseDoor()

func OpenDoor():
	openSprite.show()
	closedSprite.hide()
	centralCollider.disabled = true

func CloseDoor():
	closedSprite.show()
	openSprite.hide()
	centralCollider.disabled = false
