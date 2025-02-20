class_name  TransformationObjectData
extends StaticBody2D

@export var transformedName: String
@export var transformedSpeedTier: PCMovement.SpeedTier
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
@export var transformedAttackPath: String
@export var transformedPassivePath: String
@export var originalObjectPath: String
var transformedTextureScale: Vector2
var transformationFeedback: AnimatedSprite2D
var feedback: String = "res://ImportantObjects/TransformationObjects/GetTransformationFeedback.tscn"

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	GetScale()
	call_deferred("SpawnFeedback")

func GetScale():
	transformedTextureScale = transformedTexture.scale

func RegisterAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.SetTransformationObjectInRange(self)
	transformationFeedback.show()

func RemoveAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.UnsetTransformationObjectInRange(self)
	transformationFeedback.hide()

func SetLocalZone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func UnsetLocalZone():
	localAllowedItemsRef = null

func DestroyedSignal():
	queue_free()

func SpawnFeedback():
	var file_scene = load(feedback)
	transformationFeedback = file_scene.instantiate()
	self.add_child(transformationFeedback)
	transformationFeedback.hide()
	transformationFeedback.play("default")
	transformationFeedback.z_index = 100
	transformationFeedback.global_position = self.global_position
