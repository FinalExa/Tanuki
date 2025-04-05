class_name MovableObject
extends Area2D

@export var movableObjectName: String
var originalParent: Node2D
var originalPosition: Vector2
var collisionShape: CollisionShape2D
var playerCloseFeedbackSprite: AnimatedSprite2D
var grabbableFeedbackSprite: AnimatedSprite2D
var playerCloseFeedback: String = "res://ImportantObjects/TransformationObjects/GetTransformationFeedback.tscn"
var grabbableFeedback: String = "res://ImportantObjects/TransformationObjects/TransformableFeedback.tscn"

func _ready():
	originalParent = self.get_parent()
	originalPosition = self.global_position
	playerCloseFeedbackSprite = SpawnFeedback(playerCloseFeedback)
	playerCloseFeedbackSprite.hide()
	grabbableFeedbackSprite = SpawnFeedback(grabbableFeedback)
	GetCollisionShape()

func GetCollisionShape():
	for i in self.get_child_count():
		if (get_child(i) is CollisionShape2D):
			collisionShape = get_child(i)
			return

func AttachToPlayer(playerMoveObjects: PlayerMoveObjects):
	call_deferred("Attach", playerMoveObjects)

func Attach(playerMoveObjects: PlayerMoveObjects):
	self.reparent(playerMoveObjects)
	collisionShape.disabled = true
	self.global_position = playerMoveObjects.global_position

func ResetParent():
	call_deferred("Reset")

func Reset():
	self.reparent(originalParent)
	collisionShape.disabled = false

func ResetParentAndPosition():
	ResetParent()
	self.global_position = originalPosition

func SpawnFeedback(feedbackToSpawn: String):
	var file_scene = load(feedbackToSpawn)
	var feedbackInstance = file_scene.instantiate()
	self.add_child(feedbackInstance)
	feedbackInstance.play("default")
	feedbackInstance.z_index = 100
	feedbackInstance.global_position = self.global_position
	return feedbackInstance

func TurnCloseFeedbackOn(playerHoldingObject: MovableObject):
	if (self != playerHoldingObject):
		grabbableFeedbackSprite.hide()
		playerCloseFeedbackSprite.show()

func TurnCloseFeedbackOff(playerHoldingObject: MovableObject):
	if (self != playerHoldingObject):
		playerCloseFeedbackSprite.hide()
		grabbableFeedbackSprite.show()

func TurnBothFeedbacksOff():
	grabbableFeedbackSprite.hide()
	playerCloseFeedbackSprite.hide()
