class_name GuardRotator
extends Node2D

@export var upRad = 0
@export var leftRad = 0
@export var downRad = 0
@export var rightRad = 0
@export var lookAtOffset = 0

var isLookingAtNode: bool
var isLookingAtPosition: bool
var target: Node2D
var vectorTarget: Vector2

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

func setLookingAtNode(receivedTarget: Node2D):
	if (receivedTarget != null):
		target = receivedTarget
		isLookingAtNode = true
		isLookingAtPosition = false
	
func setLookingAtPosition(receivedPosition: Vector2):
	if (receivedPosition != null):
		vectorTarget = receivedPosition
		isLookingAtPosition = true
		isLookingAtNode = false

func stopLooking():
	isLookingAtNode = false
	isLookingAtPosition = false

func lookAtTarget():
	if (isLookingAtNode == true):
		self.look_at(target.position)
		self.rotation_degrees += lookAtOffset
	else:
		if (isLookingAtPosition == true):
			self.look_at(vectorTarget)
			self.rotation_degrees += lookAtOffset
