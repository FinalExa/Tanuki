class_name GameCamera
extends Camera2D

@export var playerRef: PlayerCharacter
@export var positionSmoothingSpeed: int
var currentTarget: Node2D

func _ready():
	ResetToPlayer(false)

func ResetToPlayer(usePositionSmoothing: bool):
	if (currentTarget != playerRef):
		SetNewCameraTarget(playerRef, usePositionSmoothing)

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
