class_name  TransformationObjectData
extends StaticBody2D

@export var transformedName: String
@export var transformedSpeedTier: PCMovement.SpeedTier
@export var transformedTimeConsumption: float = 1
@export var transformedAttackTimeConsumption: float = 1
@export var transformedProperties: Array[String]
@export var transformedCollider: CollisionShape2D
@export var transformedTexture: Sprite2D
@export var transformedAttackName: String
@export var transformedAttackPath: String
@export var transformedPassivePath: String
@export var originalObjectPath: String
var transformedTextureScale: Vector2
var playerCloseFeedbackSprite: AnimatedSprite2D
var transformableFeedbackSprite: AnimatedSprite2D
var transformationLabel: Node2D
var playerCloseFeedback: String = "res://ImportantObjects/TransformationObjects/GetTransformationFeedback.tscn"
var transformableFeedback: String = "res://ImportantObjects/TransformationObjects/TransformableFeedback.tscn"
var transformationLabelRef: String = "res://ImportantObjects/TransformationObjects/transformation_label.tscn"
var deactivated: bool

var localAllowedItemsRef: LocalAllowedItems

func _ready():
	GetScale()
	playerCloseFeedbackSprite = SpawnFeedback(playerCloseFeedback)
	playerCloseFeedbackSprite.hide()
	transformableFeedbackSprite = SpawnFeedback(transformableFeedback)
	transformationLabel = SpawnFeedback(transformationLabelRef)
	transformationLabel.get_child(0).text = transformedName
	transformationLabel.hide()

func GetScale():
	transformedTextureScale = transformedTexture.scale

func RegisterAvailableTransformation(playerRef: PlayerCharacter):
	if (!deactivated):
		playerRef.transformationChangeRef.transformationSaving.SetTransformationObjectInRange(self)
		playerCloseFeedbackSprite.show()
		transformationLabel.show()
		transformableFeedbackSprite.hide()

func RemoveAvailableTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.transformationSaving.UnsetTransformationObjectInRange(self)
	playerCloseFeedbackSprite.hide()
	transformationLabel.hide()
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
	if (feedbackInstance is AnimatedSprite2D): feedbackInstance.play("default")
	feedbackInstance.z_index = 100
	feedbackInstance.global_position = self.global_position
	return feedbackInstance

func TurnOff():
	deactivated = true

func TurnOn():
	deactivated = false
