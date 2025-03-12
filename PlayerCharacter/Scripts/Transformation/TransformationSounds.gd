class_name TransformationSounds
extends Node

@export var transformationChange: TransformationChange
@export var enterTransformationSound: AudioStreamPlayer
@export var exitTransformationSound: AudioStreamPlayer
@export var objectSavedSound: AudioStreamPlayer
@export var transformationTimeLowSound: AudioStreamPlayer

var timeLowSoundPlayed: bool

func PlayObjectSavedSound():
	objectSavedSound.play()

func PlayEnterTransformationSound():
	if (!enterTransformationSound.playing):
		enterTransformationSound.play()

func PlayDeactivateTransformation():
	if (!exitTransformationSound.playing):
		exitTransformationSound.play()
	if (transformationTimeLowSound.playing):
		transformationTimeLowSound.stop()
	timeLowSoundPlayed = false

func PlayTransformationLowSound():
	if (transformationChange.transformationTimer >= transformationChange.lowTimeRemaining && !transformationTimeLowSound.playing && !timeLowSoundPlayed):
		transformationTimeLowSound.play()
		timeLowSoundPlayed = true
