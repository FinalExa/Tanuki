class_name PlayerProgressionTrack
extends Node

var unlockKeyTypes: Array[GameplayScene.SceneType]
var unlockKeyIDs: Array[int]

var currentUnlockKeyType: GameplayScene.SceneType
var currentIDArray: Array[int]

func GenerateCurrentIDArray(newType: GameplayScene.SceneType):
	currentUnlockKeyType = newType
	currentIDArray.clear()
	for i in unlockKeyTypes.size():
		if (unlockKeyTypes[i] == currentUnlockKeyType):
			currentIDArray.push_back(unlockKeyIDs[i])

func RegisterKey(id: int):
	if (!currentIDArray.has(id)):
		unlockKeyTypes.push_back(currentUnlockKeyType)
		unlockKeyIDs.push_back(id)
