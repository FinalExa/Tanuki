class_name TransformationLock
extends Node

@export var transformationChange: TransformationChange
@export var transformationLockDuration: float
var transformationLockTimer: float

func ActivateLock():
	transformationChange.transformationLocked = true
	transformationLockTimer = 0

func LockTimer(delta):
	if (transformationChange.transformationLocked):
		if (transformationLockTimer < transformationLockDuration):
			transformationLockTimer += delta
		else:
			transformationChange.transformationLocked = false
