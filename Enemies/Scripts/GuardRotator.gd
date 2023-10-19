class_name GuardRotator
extends Node2D

@export var upRad = 0
@export var downRad = 0
@export var leftRad = 0
@export var rightRad = 0
var lastDirection = Vector2(0,0)

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
