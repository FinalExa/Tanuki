class_name  TransformationObjectData
extends StaticBody2D

signal set_trs_ready
signal set_trs_notReady

@export var transformedName: String
@export var transformedMaxSpeed: float
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
var transformedTextureScale: Vector2

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	transformedTextureScale = transformedTexture.scale

func set_change_trs_available(status, body):
	if (status == true):
		body.set_trs_ready(transformedName, transformedMaxSpeed, transformedProperties, transformedCollider, transformedTexture.texture, transformedTextureScale)
	else:
		body.set_trs_not_ready()

func set_local_zone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func unset_local_zone():
	localAllowedItemsRef = null
