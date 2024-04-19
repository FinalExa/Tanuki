class_name PlayerMovementSounds
extends Node2D

@export var playerMovement: PCMovement
@export var playerRef: PlayerCharacter
@export var currentNormalStep: AudioStreamPlayer
@export var normalMovementSounds: Array[AudioStreamPlayer]
@export var transformedMovementSound: AudioStreamPlayer
var currentStepIndex: int
var normalStepsStarted: bool

func _process(_delta):
	PlayMovementSounds()

func PlayMovementSounds():
	if (playerMovement.inputDirection != Vector2.ZERO && playerMovement.movementEnabled):
		if (!playerRef.transformationChangeRef.isTransformed): PlayNormalMovement()
		else: PlayTransformedMovement()
	else: StopMovementSounds()

func PlayNormalMovement():
	if (transformedMovementSound.playing):
		transformedMovementSound.stop()
	if (!currentNormalStep.playing):
		SelectNextStep()

func SelectNextStep():
	currentStepIndex = randi_range(0, normalMovementSounds.size() - 1)
	if (!normalStepsStarted):
		if (!normalStepsStarted):
			normalStepsStarted = true
	else:
		if (normalMovementSounds[currentStepIndex].stream == currentNormalStep.stream):
			var rand = randi_range(1, normalMovementSounds.size() - 2)
			currentStepIndex += rand
			if (currentStepIndex >= normalMovementSounds.size()):
				currentStepIndex -= normalMovementSounds.size()
	currentNormalStep.stream = normalMovementSounds[currentStepIndex].stream
	currentNormalStep.play()

func StopNormalMovementSound():
	currentNormalStep.stop()
	normalStepsStarted = false

func PlayTransformedMovement():
	if (currentNormalStep.playing):
		StopNormalMovementSound()
	if (!transformedMovementSound.playing):
		transformedMovementSound.play()

func StopMovementSounds():
	if (currentNormalStep.playing): StopNormalMovementSound()
	if (transformedMovementSound.playing): transformedMovementSound.stop()
