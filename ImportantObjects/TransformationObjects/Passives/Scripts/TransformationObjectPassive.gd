class_name TransformationObjectPassive
extends Node2D

var characterRef
var transformationChangeRef: TransformationChange

func SetTransformationChangeRef(ref: TransformationChange):
	transformationChangeRef = ref
	AssignExtraRefs()

func AssignExtraRefs():
	pass
