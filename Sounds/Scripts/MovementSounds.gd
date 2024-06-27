class_name MovementSounds
extends Node

func RandomizeStepSound(stepSound: AudioStreamPlayer, currentStepSound: AudioStreamPlayer, arrayOfStepSounds: Array[AudioStreamPlayer], index: int):
	if (stepSound.stream == currentStepSound.stream):
		var rand = randi_range(1, arrayOfStepSounds.size() - 2)
		index += rand
		if (index >= arrayOfStepSounds.size()):
			index -= arrayOfStepSounds.size()
	return index
