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
var playerCloseFeedbackSprite: AnimatedSprite2D
var transformableFeedbackSprite: AnimatedSprite2D
var playerCloseFeedback: String = "res://ImportantObjects/TransformationObjects/GetTransformationFeedback.tscn"
var transformableFeedback: String = "res://ImportantObjects/TransformationObjects/TransformableFeedback.tscn"

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	GetScale()
	playerCloseFeedbackSprite = SpawnFeedback(playerCloseFeedback)
	playerCloseFeedbackSprite.hide()
	transformableFeedbackSprite = SpawnFeedback(transformableFeedback)

func GetScale():
	transformedTextureScale = transformedTexture.scale

func RegisterAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.SetTransformationObjectInRange(self)
	playerCloseFeedbackSprite.show()
	transformableFeedbackSprite.hide()

func RemoveAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.UnsetTransformationObjectInRange(self)
	playerCloseFeedbackSprite.hide()
	transformableFeedbackSprite.show()

func SetLocalZone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func UnsetLocalZone():
	localAllowedItemsRef = null

func DestroyedSignal():
	queue_free()

func SpawnFeedback(feedbackToSpawn: String):
	var file_scene = load(feedbackToSpawn)
	var feedbackInstance = file_scene.instantiate()
	self.add_child(feedbackInstance)
	feedbackInstance.play("default")
	feedbackInstance.z_index = 100
	feedbackInstance.global_position = self.global_position
	return feedbackInstance
