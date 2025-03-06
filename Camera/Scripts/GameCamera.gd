class_name GameCamera
extends Camera2D

@export var playerRef: PlayerCharacter
@export var positionSmoothingSpeed: int
var currentTarget: Node2D

func _ready():
	ResetToPlayer()

func ResetToPlayer():
	if (currentTarget != playerRef):
		SetNewCameraTarget(playerRef)

func AssignTarget(target: Node2D):
	currentTarget = target
	reparent(currentTarget)
	self.position = Vector2.ZERO

func SetNewCameraTarget(target: Node2D):
	call_deferred("AssignTarget", target)
