class_name  TransformationObjectData
extends StaticBody2D

@export var transformedName: String
@export var transformedMaxSpeed: float
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
@export var transformedAttackPath: String
var transformedTextureScale: Vector2

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	transformedTextureScale = transformedTexture.scale

func set_change_trs_available(status, body):
	if (status == true):
		body.transformationChangeRef.set_temp_trs(transformedName, transformedMaxSpeed, transformedProperties, transformedCollider, transformedTexture.texture, transformedTextureScale, transformedAttackPath)
	else:
		body.transformationChangeRef.unset_temp_trs()

func set_local_zone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func unset_local_zone():
	localAllowedItemsRef = null