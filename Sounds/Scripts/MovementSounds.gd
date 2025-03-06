class_name MovementSounds
extends Node

var firstStepDone: bool
var currentStepIndex: int
var currentSoundArray: Array[AudioStreamPlayer2D]
@export var currentMovementSound: AudioStreamPlayer2D

func RandomizeStepSound(stepSound, currentStepSound, arrayOfStepSounds, index: int):
	if (stepSound.stream == currentStepSound.stream):
		var rand = randi_range(1, arrayOfStepSounds.size() - 2)
		index += rand
		if (index >= arrayOfStepSounds.size()):
			index -= arrayOfStepSounds.size()
	return index

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

func SetSoundsArray(newArray: Array[AudioStreamPlayer2D]):
	currentSoundArray.clear()
	for i in newArray.size():
		currentSoundArray.push_back(newArray[i])

func ResetFirstStep():
	if (currentMovementSound.playing):
		currentMovementSound.stop()
	if (firstStepDone):
		firstStepDone = false
