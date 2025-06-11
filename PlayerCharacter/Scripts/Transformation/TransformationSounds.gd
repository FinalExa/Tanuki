class_name TransformationSounds
extends Node

@export var transformationChange: TransformationChange
@export var enterTransformationSound: AudioStreamPlayer
@export var exitTransformationSound: AudioStreamPlayer
@export var objectSavedSound: AudioStreamPlayer
@export var transformationTimeLowSound: AudioStreamPlayer
@export var transformationRemovedSound: AudioStreamPlayer

var timeLowSoundPlayed: bool

func PlayObjectSavedSound():
	objectSavedSound.play()

func PlayEnterTransformationSound():
	if (!enterTransformationSound.playing):
		enterTransformationSound.play()
	var gameplayScene: GameplayScene = get_tree().root.get_child(0).sceneSelector.currentScene
	gameplayScene.gameplaySceneSoundtrack.ActivateTransformed()

func PlayDeactivateTransformation():
	if (!exitTransformationSound.playing):
		exitTransformationSound.play()
	if (transformationTimeLowSound.playing):
		transformationTimeLowSound.stop()
	var gameplayScene: GameplayScene = get_tree().root.get_child(0).sceneSelector.currentScene
	gameplayScene.gameplaySceneSoundtrack.DeactivateTransformed()
	timeLowSoundPlayed = false

func PlayTransformationLowSound():
	if (transformationChange.transformationTimer >= transformationChange.lowTimeRemaining && !transformationTimeLowSound.playing && !timeLowSoundPlayed):
		transformationTimeLowSound.play()
		timeLowSoundPlayed = true

func PlayTransformationRemovedSound():
	if (transformationChange.currentTransformationSet):
		transformationRemovedSound.play()
