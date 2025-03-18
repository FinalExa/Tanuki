class_name TransformationObjectPassive
extends Node2D

var characterRef
var transformationChangeRef: TransformationChange

func _ready():
	ReadyOperations()

func ReadyOperations():
	pass

func SetTransformationChangeRef(ref: TransformationChange):
	transformationChangeRef = ref
	AssignExtraRefs()

func AssignExtraRefs():
	pass

func TransformationInvincibilityInteracted(_receivedNode: Node2D):
	pass
