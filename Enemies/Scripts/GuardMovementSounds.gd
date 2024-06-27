class_name GuardMovementSounds
extends MovementSounds

@export var guardController: GuardController
@export var patrolMovementSounds: Array[AudioStreamPlayer2D]
@export var alertMovementSounds: Array[AudioStreamPlayer2D]
@export var currentMovementSound: AudioStreamPlayer2D
var lastState: bool
var firstStepDone: bool
var currentStepIndex: int
var currentSoundArray: Array[AudioStreamPlayer2D]

func _ready():
	SwitchLastState(false, patrolMovementSounds)

func _process(_delta):
	PlayMovementSounds()

func PlayMovementSounds():
	if (lastState != guardController.isInAlert):
		if (guardController.isInAlert):
			SwitchLastState(guardController.isInAlert, alertMovementSounds)
		else:
			SwitchLastState(guardController.isInAlert, patrolMovementSounds)
		return
	if (guardController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			SelectNextStep()
	else:
		currentMovementSound.stop()

func SelectNextStep():
	RandomizeStep()
	currentMovementSound.stream = currentSoundArray[currentStepIndex].stream
	currentMovementSound.play()

func RandomizeStep():
	currentStepIndex = randi_range(0, currentSoundArray.size() - 1)
	if (!firstStepDone):
		firstStepDone = true
		return
	currentStepIndex = RandomizeStepSound(currentSoundArray[currentStepIndex], currentMovementSound, currentSoundArray, currentStepIndex)

func SwitchLastState(newState: bool, newArray: Array[AudioStreamPlayer2D]):
	lastState = newState
	firstStepDone = false
	currentSoundArray = newArray
