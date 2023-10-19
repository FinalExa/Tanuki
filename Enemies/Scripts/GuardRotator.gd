class_name GuardRotator
extends Node2D

@export var upRad = 0
@export var leftRad = 0
@export var downRad = 0
@export var rightRad = 0
@export var lookAtOffset = 0

var isLookingAtSomething: bool
var target: Node2D

@export var mainNodeRef: Node2D

func _process(_delta):
	lookAtTarget()

func rotateTo(givenPoint):
	if (givenPoint == GuardController.LookDirections.UP):
		self.rotation_degrees = upRad
	else:
		if (givenPoint == GuardController.LookDirections.DOWN):
			self.rotation_degrees = downRad
		else:
			if (givenPoint == GuardController.LookDirections.LEFT):
				self.rotation_degrees = leftRad
			else:
				self.rotation_degrees = rightRad

func setLookingAtSomething(receivedTarget):
	target = receivedTarget
	isLookingAtSomething = true

func stopLooking():
	isLookingAtSomething = false

func lookAtTarget():
	if(isLookingAtSomething == true):
		self.look_at(target.position)
		self.rotation_degrees += lookAtOffset
