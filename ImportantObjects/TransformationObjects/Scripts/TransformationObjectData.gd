class_name  TransformationObjectData
extends StaticBody2D

@export var transformedName: String
@export var transformedSpeedTier: PCMovement.SpeedTier
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
@export var transformedAttackPath: String
@export var transformedPassivePath: String
@export var transformedTailLocation: Node2D
@export var originalObjectPath: String
var transformedTextureScale: Vector2

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	GetScale()

func GetScale():
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
	queue_free()
