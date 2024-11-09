class_name PuzzleObject
extends Node2D

@export var activated: bool
@export var collisionShapeRef: CollisionShape2D

func _ready():
	ReadyOperations()
	ExecuteActivationStatus()

func InteractSignal():
	activated = !activated
	ExecuteActivationStatus()

func ReadyOperations():
	pass

func ExecuteActivationStatus():
	if (activated):
		Activation()
		return
	Deactivation()

func Activation():
	self.show()
	collisionShapeRef.disabled = false

func Deactivation():
	self.hide()
	collisionShapeRef.disabled = true
