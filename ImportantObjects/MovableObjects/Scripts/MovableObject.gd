class_name MovableObject
extends Area2D

@export var movableObjectName: String
@export var movableObjectProperties: Array[String]
var originalParent: Node2D
var originalPosition: Vector2
var collisionShape: CollisionShape2D
@export var movableFeedbackFar: AnimatedSprite2D
@export var movableFeedbackClose: AnimatedSprite2D

func _ready():
	originalParent = self.get_parent()
	originalPosition = self.global_position
	GetCollisionShape()
	ForceTurnCloseFeedbackOff()

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
		movableFeedbackFar.hide()
		movableFeedbackClose.show()

func TurnCloseFeedbackOff(playerHoldingObject: MovableObject):
	if (self != playerHoldingObject):
		ForceTurnCloseFeedbackOff()

func ForceTurnCloseFeedbackOff():
	movableFeedbackClose.hide()
	movableFeedbackFar.show()

func TurnBothFeedbacksOff():
	movableFeedbackClose.hide()
	movableFeedbackFar.hide()
