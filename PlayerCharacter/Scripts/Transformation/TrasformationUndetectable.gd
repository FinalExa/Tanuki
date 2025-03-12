class_name TrasformationUndetectable
extends Node

@export var transformationChange: TransformationChange
@export var undetectableDuration: float
var undetectableTimer: float


func UndetectableActivate():
	if (!transformationChange.undetectable):
		undetectableTimer = undetectableDuration
		transformationChange.undetectable = true

func UndetectableTimer(delta):
	if (transformationChange.undetectable):
		if (undetectableTimer > 0):
			undetectableTimer -= delta
			return
		transformationChange.undetectable = false
