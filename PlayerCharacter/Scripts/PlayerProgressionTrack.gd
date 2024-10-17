class_name PlayerProgressionTrack
extends Node

var unlockKeyTypes: Array[GameplayScene.SceneType]
var unlockKeyIDs: Array[int]
var usedUnlockKeyForDoors: Array[int]

var currentUnlockKeyType: GameplayScene.SceneType
var currentIDArray: Array[int]
var currentUsedKeysArray: Array[int]

func GenerateCurrentIDArray(newType: GameplayScene.SceneType):
	currentUnlockKeyType = newType
	currentIDArray.clear()
	currentUsedKeysArray.clear()
	for i in unlockKeyTypes.size():
		if (unlockKeyTypes[i] == currentUnlockKeyType):
			currentIDArray.push_back(unlockKeyIDs[i])
			currentUsedKeysArray.push_back(usedUnlockKeyForDoors[i])

func RegisterKey(id: int):
	if (!currentIDArray.has(id)):
		unlockKeyTypes.push_back(currentUnlockKeyType)
		unlockKeyIDs.push_back(id)
		usedUnlockKeyForDoors.push_back(-1)

func AssignKeysToDoor(keyDoor: LevelUnlockKeyDoor):
	var gameplayScene: GameplayScene = get_tree().root.get_child(0).sceneSelector.currentScene
	FillUseForDoors(GetCurrentDoorID(gameplayScene, keyDoor), keyDoor)

func GetCurrentDoorID(gameplayScene: GameplayScene, keyDoor: LevelUnlockKeyDoor):
	for i in gameplayScene.levelUnlockKeyDoors.size():
		if (gameplayScene.levelUnlockKeyDoors[i] == keyDoor):
			return i

func FillUseForDoors(doorID: int, keyDoor: LevelUnlockKeyDoor):
	for i in usedUnlockKeyForDoors.size():
		if (unlockKeyTypes[i] == currentUnlockKeyType && usedUnlockKeyForDoors[i] == -1):
			usedUnlockKeyForDoors[i] = doorID
			keyDoor.RegisterKey(unlockKeyIDs[i])
