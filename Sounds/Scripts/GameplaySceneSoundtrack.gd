class_name GameplaySceneSoundtrack
extends Node

@export var baseSoundtrack: AudioStreamPlayer
@export var transformedSoundtrack: AudioStreamPlayer
@export var specialRoomSoundTrack: AudioStreamPlayer

func _ready():
	PlayAll()

func PlayAll():
	baseSoundtrack.play()
	transformedSoundtrack.play()
	transformedSoundtrack.volume_db = -80.0
	specialRoomSoundTrack.play()
	specialRoomSoundTrack.volume_db = -80.0

func SetSoundtrackVolume(soundtrack: AudioStreamPlayer, volume: float):
	soundtrack.volume_db = volume

func ActivateTransformed():
	SetSoundtrackVolume(transformedSoundtrack, 0)

func DeactivateTransformed():
	SetSoundtrackVolume(transformedSoundtrack, -80.0)

func ActivateSpecialRoom():
	SetSoundtrackVolume(baseSoundtrack, -80.0)
	SetSoundtrackVolume(specialRoomSoundTrack, -10.0)

func DeactivateSpecialRoom():
	SetSoundtrackVolume(specialRoomSoundTrack, -80.0)
	SetSoundtrackVolume(baseSoundtrack, 0)
