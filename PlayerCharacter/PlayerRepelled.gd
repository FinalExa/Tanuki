class_name PlayerRepelled
extends Node

@export var playerRef: PlayerCharacter

var repelled: bool
var launchSpeed: Vector2
var launchTime: float

func _process(delta):
	Repelled(delta)

func Repelled(delta):
	if (repelled):
		if (launchTime > 0):
			launchTime -= delta
			playerRef.velocity = launchSpeed
		else:
			playerRef.velocity = Vector2.ZERO
			repelled = false
			playerRef.playerInputs.inputsLocked = false

func SetRepelled(distance: float, time: float, direction: Vector2):
	launchSpeed = (distance / time) * direction
	launchTime = time
	repelled = true
	playerRef.playerInputs.SetInputsToZero()
	playerRef.velocity = Vector2.ZERO
	playerRef.playerInputs.inputsLocked = true
