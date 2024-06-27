class_name PlayerMovementSounds
extends MovementSounds

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
	if (playerRef.playerInputs.inputDirection != Vector2.ZERO && playerMovement.movementEnabled):
		if (!playerRef.transformationChangeRef.isTransformed): PlayNormalMovement()
		else: PlayTransformedMovement()
	else: StopMovementSounds()

func PlayNormalMovement():
	if (transformedMovementSound.playing):
		transformedMovementSound.stop()
	if (!currentNormalStep.playing):
		SelectNextStep()

func SelectNextStep():
	RandomizeStep()
	currentNormalStep.stream = normalMovementSounds[currentStepIndex].stream
	currentNormalStep.play()

func RandomizeStep():
	currentStepIndex = randi_range(0, normalMovementSounds.size() - 1)
	if (!normalStepsStarted):
		normalStepsStarted = true
		return
	currentStepIndex = RandomizeStepSound(normalMovementSounds[currentStepIndex], currentNormalStep, normalMovementSounds, currentStepIndex)

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
