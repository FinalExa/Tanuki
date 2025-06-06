class_name DoorOpenClose
extends Node2D

@export var startOpen: bool
@export var centralCollider: CollisionShape2D
@export var closedSprite: Sprite2D
@export var openSprite: Sprite2D
var opened: bool

func _ready():
	if (startOpen):
		OpenDoor()
	else:
		CloseDoor()

func OpenDoor():
	openSprite.show()
	closedSprite.hide()
	centralCollider.disabled = true
	opened = true

func CloseDoor():
	closedSprite.show()
	openSprite.hide()
	centralCollider.disabled = false
	opened = false
