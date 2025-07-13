class_name GameplaySceneSoundtrack
extends Node

var defaultVolume: float = -10.0
var minVolume: float = -80.0
@export var baseSoundtrack: AudioStreamPlayer
@export var transformedSoundtrack: AudioStreamPlayer
@export var specialRoomSoundTrack: AudioStreamPlayer

func _ready():
	PlayAll()

func PlayAll():
	baseSoundtrack.play()
	baseSoundtrack.volume_db = defaultVolume
	transformedSoundtrack.play()
	transformedSoundtrack.volume_db = -80.0
	specialRoomSoundTrack.play()
	specialRoomSoundTrack.volume_db = -80.0

func SetSoundtrackVolume(soundtrack: AudioStreamPlayer, volume: float):
	soundtrack.volume_db = volume

func ActivateTransformed():
	SetSoundtrackVolume(transformedSoundtrack, defaultVolume)

func DeactivateTransformed():
	SetSoundtrackVolume(transformedSoundtrack, minVolume)

func ActivateSpecialRoom():
	SetSoundtrackVolume(baseSoundtrack, minVolume)
	SetSoundtrackVolume(specialRoomSoundTrack, defaultVolume)

func DeactivateSpecialRoom():
	SetSoundtrackVolume(specialRoomSoundTrack, minVolume)
	SetSoundtrackVolume(baseSoundtrack, defaultVolume)
