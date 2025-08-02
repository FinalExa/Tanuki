class_name MovableObject
extends Area2D

signal on_attach
signal on_attach_end
signal on_force_detach

var playerMoveObjects: PlayerMoveObjects
@export var movableObjectName: String
@export var movableObjectProperties: Array[String]
var originalParent: Node2D
var originalPosition: Vector2
var collisionShape: CollisionShape2D
@export var movableFeedbackFar: AnimatedSprite2D
@export var movableFeedbackClose: AnimatedSprite2D
@export var movableLabel: Label

func _ready():
	originalParent = self.get_parent()
	originalPosition = self.global_position
	GetCollisionShape()
	ForceTurnCloseFeedbackOff()
	movableLabel.text = movableObjectName
	ReadyOperations()

func ReadyOperations():
	pass

func GetCollisionShape():
	for i in self.get_child_count():
		if (get_child(i) is CollisionShape2D):
			collisionShape = get_child(i)
			return

func AttachToPlayer(playerMoveObjects: PlayerMoveObjects):
	call_deferred("Attach", playerMoveObjects)

func Attach(mov: PlayerMoveObjects):
	playerMoveObjects = mov
	self.reparent(playerMoveObjects)
	collisionShape.disabled = true
	self.global_position = playerMoveObjects.global_position
	emit_signal("on_attach")

func ResetParent():
	call_deferred("Reset")

func Reset():
	self.reparent(originalParent)
	collisionShape.disabled = false
	emit_signal("on_attach_end")
	playerMoveObjects = null

func ResetParentAndPosition():
	ResetParent()
	self.global_position = originalPosition
	emit_signal("on_force_detach")

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
		movableLabel.show()
		movableFeedbackClose.show()

func TurnCloseFeedbackOff(playerHoldingObject: MovableObject):
	if (self != playerHoldingObject):
		ForceTurnCloseFeedbackOff()

func ForceTurnCloseFeedbackOff():
	movableFeedbackClose.hide()
	movableLabel.hide()
	movableFeedbackFar.show()

func TurnAllFeedbacksOff():
	movableFeedbackClose.hide()
	movableFeedbackFar.hide()
	movableLabel.hide()
