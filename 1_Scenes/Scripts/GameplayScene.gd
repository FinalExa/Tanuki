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

@export var mapQuests: Array[MapQuest]

@export var travelingAreas: Array[TravelingArea]

func _ready():
	SetKeys()
	SetQuests()

func SetKeys():
	if (levelUnlockKeys.size() > 0):
		for i in levelUnlockKeys.size():
			levelUnlockKeys[i].gameplayScene = self

func SetQuests():
	if (mapQuests.size() > 0):
		var playerRef: PlayerCharacter = get_tree().root.get_child(0).sceneSelector.playerRef
		for i in mapQuests.size():
			mapQuests[i].gameplayScene = self
			mapQuests[i].SetLastStage()
			mapQuests[i].ExecuteCurrentStage()
			AdvanceQuestToPlayerProgress(mapQuests[i], playerRef.playerProgressionTrack)

func AdvanceQuestToPlayerProgress(quest: MapQuest, progression: PlayerProgressionTrack):
	if (progression.activeQuests.has(quest.questName)):
		for i in progression.activeQuests.size():
			if (progression.activeQuests[i] == quest.questName):
				quest.AdvanceToStage(progression.activeQuestsStages[i])
				return

func SaveQuestProgressToPlayer(questName: String, questStage: int):
	var playerRef: PlayerCharacter = get_tree().root.get_child(0).sceneSelector.playerRef
	playerRef.playerProgressionTrack.RegisterQuestWithStage(questName, questStage)

func SetCurrentKeysForPlayer(playerRef: PlayerCharacter):
	if (levelUnlockKeys.size() > 0):
		playerRef.playerProgressionTrack.GenerateCurrentIDArray(sceneType)
		var currentIDArray: Array[int] = playerRef.playerProgressionTrack.currentIDArray
		var currentUsedArray: Array[int] = playerRef.playerProgressionTrack.currentUsedKeysArray
		for i in currentIDArray.size():
			levelUnlockKeys[currentIDArray[i]].AlreadyGotThisKey()
			if (currentUsedArray[i] != -1):
				levelUnlockKeyDoors[currentUsedArray[i]].RegisterKey(currentIDArray[i])

func SetPlayerSpawn(playerRef: PlayerCharacter):
	if (playerRef.isTraveling && travelingAreas.size() > 0):
		playerRef.global_position = travelingAreas[playerRef.travelId].spawnLocation.global_position
		return
	playerRef.global_position = playerSpawnPoint.global_position
