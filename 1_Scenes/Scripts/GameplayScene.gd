class_name GameplayScene
extends Node2D

enum SceneType
{
	TEST,
	KITCHEN
}

@export var playerSpawnPoint: Node2D

@export var sceneType: SceneType
@export var levelUnlockKeys: Array[LevelUnlockKey]
@export var levelUnlockKeyDoors: Array[LevelUnlockKeyDoor]

@export var travelingAreas: Array[TravelingArea]

func _ready():
	SetKeys()

func SetKeys():
	if (levelUnlockKeys.size() > 0):
		for i in levelUnlockKeys.size():
			levelUnlockKeys[i].gameplayScene = self

func SetCurrentKeysForPlayer(playerRef: PlayerCharacter):
	if (levelUnlockKeys.size() > 0):
		playerRef.playerProgressionTrack.GenerateCurrentIDArray(sceneType)
		var currentIDArray: Array[int] = playerRef.playerProgressionTrack.currentIDArray
		for i in currentIDArray.size():
			levelUnlockKeys[currentIDArray[i]].AlreadyGotThisKey()

func SetPlayerSpawn(playerRef: PlayerCharacter):
	if (playerRef.isTraveling && travelingAreas.size() > 0):
		playerRef.global_position = travelingAreas[playerRef.travelId].spawnLocation.global_position
		return
	playerRef.global_position = playerSpawnPoint.global_position
