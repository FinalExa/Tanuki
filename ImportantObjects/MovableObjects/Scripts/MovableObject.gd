class_name MovableObject
extends Area2D

@export var movableObjectName: String
var originalParent: Node2D
var originalPosition: Vector2
var collisionShape: CollisionShape2D

func _ready():
	originalParent = self.get_parent()
	originalPosition = self.global_position
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
