class_name GuardRotator
extends Node2D

@export var upRotationPoint: Node2D
@export var downRotationPoint: Node2D
@export var leftRotationPoint: Node2D
@export var rightRotationPoint: Node2D
@export var lookAtOffset = 0

var isLookingAtNode: bool
var isLookingAtPosition: bool
var target: Node2D
var vectorTarget: Vector2

@export var mainNodeRef: Node2D
@export var rotationSpeed: float
@export var rotationWeight: float
@export var rotationDegreesOffset: float

func _physics_process(delta):
	lookAtTarget(delta)

func rotateTo(givenPoint):
	if (givenPoint == GuardController.LookDirections.UP):
		setLookingAtNode(upRotationPoint)
	else:
		if (givenPoint == GuardController.LookDirections.DOWN):
			setLookingAtNode(downRotationPoint)
		else:
			if (givenPoint == GuardController.LookDirections.LEFT):
				setLookingAtNode(leftRotationPoint)
			else:
				setLookingAtNode(rightRotationPoint)

func setLookingAtNode(receivedTarget: Node2D):
	if (receivedTarget != null && ((receivedTarget != target && isLookingAtNode) || (!isLookingAtNode))):
		target = receivedTarget
		isLookingAtNode = true
		isLookingAtPosition = false
	
func setLookingAtPosition(receivedPosition: Vector2):
	if (receivedPosition != null && ((receivedPosition != vectorTarget && isLookingAtPosition) || (!isLookingAtPosition))):
		vectorTarget = receivedPosition
		isLookingAtPosition = true
		isLookingAtNode = false

func stopLooking():
	isLookingAtNode = false
	isLookingAtPosition = false

func lookAtTarget(delta):
	if (isLookingAtNode == true):
		execute_rotation(target.global_position, delta)
	else:
		if (isLookingAtPosition == true):
			execute_rotation(vectorTarget, delta)

func execute_rotation(rotationDestination: Vector2, delta):
	var angle = (rotationDestination - mainNodeRef.global_position).angle() + lookAtOffset
	if (angle < rotation_degrees - rotationDegreesOffset || angle > rotation_degrees + rotationDegreesOffset):
		var glb_rotation = global_rotation
		var angle_delta = rotationSpeed * delta
		angle = lerp_angle(glb_rotation, angle, rotationWeight)
		angle = clamp(angle, glb_rotation - angle_delta, glb_rotation + angle_delta)
		global_rotation = angle
