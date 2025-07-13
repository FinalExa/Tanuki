class_name WaterwayComponent
extends StaticBody2D

@export var waterSprite: Sprite2D
@export var heatedSprite: Sprite2D
@export var hasBridge: bool
@export var bridgeLowSprite: Sprite2D
@export var bridgeHighSprite: Sprite2D
@export var removableCollisionShape: CollisionShape2D

func SetNoWater():
	waterSprite.hide()
	heatedSprite.hide()
	if (hasBridge): bridgeLowSprite.show()
	else: bridgeLowSprite.hide()
	bridgeHighSprite.hide()
	removableCollisionShape.disabled = false

func SetWater(isHeated: bool):
	waterSprite.show()
	if (hasBridge):
		bridgeLowSprite.hide()
		bridgeHighSprite.show()
		removableCollisionShape.disabled = true
	if (isHeated):
		heatedSprite.show()
	else:
		heatedSprite.hide()
