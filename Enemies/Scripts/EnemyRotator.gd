class_name EnemyRotator
extends Node2D

@export var upRotationPoint: Node2D
@export var downRotationPoint: Node2D
@export var leftRotationPoint: Node2D
@export var rightRotationPoint: Node2D
@export var lookAtOffset: float

var isLookingAtNode: bool
var isLookingAtPosition: bool
var target: Node2D
var vectorTarget: Vector2
var isDoneRotating: bool

@export var mainNodeRef: Node2D
@export var rotationSpeed: float
@export var rotationWeight: float
@export var rotationDegreesOffset: float

func _physics_process(delta):
	LookAtTarget(delta)

func rotateTo(givenPoint):
	if (givenPoint == PatrolIndicator.LookDirections.UP):
		setLookingAtNode(upRotationPoint)
	else:
		if (givenPoint == PatrolIndicator.LookDirections.DOWN):
			setLookingAtNode(downRotationPoint)
		else:
			if (givenPoint == PatrolIndicator.LookDirections.LEFT):
				setLookingAtNode(leftRotationPoint)
			else:
				setLookingAtNode(rightRotationPoint)

func setLookingAtNode(receivedTarget: Node2D):
	if (receivedTarget != null && ((receivedTarget != target && isLookingAtNode) || (!isLookingAtNode))):
		target = receivedTarget
		isLookingAtNode = true
		isLookingAtPosition = false
		isDoneRotating = false
	
func setLookingAtPosition(receivedPosition: Vector2):
	if (receivedPosition != null && ((receivedPosition != vectorTarget && isLookingAtPosition) || (!isLookingAtPosition))):
		vectorTarget = receivedPosition
		isLookingAtPosition = true
		isLookingAtNode = false
		isDoneRotating = false

func stopLooking():
	isLookingAtNode = false
	isLookingAtPosition = false
	isDoneRotating = true

func LookAtTarget(delta):
	if (isLookingAtNode && target != null):
		execute_rotation(target.global_position, delta)
	else:
		if (isLookingAtPosition):
			execute_rotation(vectorTarget, delta)

func execute_rotation(rotationDestination: Vector2, delta):
	var angle = (mainNodeRef.global_position.direction_to(rotationDestination)).angle() + deg_to_rad(lookAtOffset)
	var deg = rotation_degrees
	if (deg < 0 ):
		deg += 360
	if (rad_to_deg(angle)<0):
		angle = deg_to_rad(rad_to_deg(angle) + 360)
	if (angle < deg_to_rad(deg - rotationDegreesOffset) || angle > deg_to_rad(deg + rotationDegreesOffset)):
		var glb_rotation = global_rotation
		var angle_delta = rotationSpeed * delta
		angle = lerp_angle(glb_rotation, angle, rotationWeight)
		angle = clamp(angle, glb_rotation - angle_delta, glb_rotation + angle_delta)
		global_rotation = angle
		isDoneRotating = false
	else:
		isDoneRotating = true

func get_current_look_direction():
	var direction: Vector2
	if (isLookingAtNode):
		direction = mainNodeRef.global_position.direction_to(target.global_position)
	else:
		direction = mainNodeRef.global_position.direction_to(vectorTarget)
	return direction
