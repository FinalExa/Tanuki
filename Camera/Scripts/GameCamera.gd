class_name GameCamera
extends Camera2D

@export var playerRef: PlayerCharacter
@export var positionSmoothingSpeed: int
var currentTarget: Node2D

func _ready():
	SetNewCameraTarget(playerRef, false)

func AssignTarget(target: Node2D, usePositionSmoothing: bool):
	currentTarget = target
	reparent(currentTarget)
	SetPositionSmoothing(usePositionSmoothing)
	self.position = Vector2.ZERO

func SetNewCameraTarget(target: Node2D, usePositionSmoothing: bool):
	call_deferred("AssignTarget", target, usePositionSmoothing)

func SetPositionSmoothing(usePositionSmoothing: bool):
	position_smoothing_enabled = usePositionSmoothing
	if (usePositionSmoothing):
		position_smoothing_speed = positionSmoothingSpeed
