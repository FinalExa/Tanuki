class_name  TransformationObjectData
extends StaticBody2D

@export var transformedName: String
@export var transformedMaxSpeed: float
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
@export var transformedAttackPath: String
@export var transformedPassivePath: String
@export var transformedTailLocation: Node2D
var originalObjectPath: String
var transformedTextureScale: Vector2

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	originalObjectPath = scene_file_path
	transformedTextureScale = transformedTexture.scale

func RegisterAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.SetTransformationObjectInRange(self)

func RemoveAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.UnsetTransformationObjectInRange(self)

func SetLocalZone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func UnsetLocalZone():
	localAllowedItemsRef = null

func DestroyedSignal():
	get_parent().remove_child(self)
