class_name GameplayScene
extends Node2D

enum SceneType
{
	TEST,
	KITCHEN,
	KITCHEN_ROOF
}

@export var playerSpawnPoint: Node2D

@export var sceneType: SceneType
@export var levelUnlockKeys: Array[LevelUnlockKey]
@export var levelUnlockKeyDoors: Array[LevelUnlockKeyDoor]

@export var mapQuests: Array[MapQuest]
@export var unlocksAfterQuestStages: Array[UnlocksAfterQuestStage]

@export var travelingAreas: Array[TravelingArea]
@export var travelingReceivers: Array[Node2D]

var localAllowedItems: Array[LocalAllowedItems]
var playerRef: PlayerCharacter

func Initialize():
	playerRef = get_tree().root.get_child(0).sceneSelector.playerRef
	SetKeys()
	SetQuests()

func SetKeys():
	if (levelUnlockKeys.size() > 0):
		for i in levelUnlockKeys.size():
			levelUnlockKeys[i].gameplayScene = self

func SetQuests():
	if (mapQuests.size() > 0):
		for i in mapQuests.size():
			mapQuests[i].gameplayScene = self
			mapQuests[i].SetLastStage()
			mapQuests[i].ExecuteCurrentStage(false, false)
			AdvanceQuestToPlayerProgress(mapQuests[i], playerRef.playerProgressionTrack)
	if (unlocksAfterQuestStages.size() > 0):
		for i in playerRef.playerProgressionTrack.activeQuests.size():
			CheckForUnlocksAfterQuest(playerRef.playerProgressionTrack.activeQuests[i], playerRef.playerProgressionTrack.activeQuestsStages[i])

func AdvanceQuestToPlayerProgress(quest: MapQuest, progression: PlayerProgressionTrack):
	if (progression.activeQuests.has(quest.questName)):
		for i in progression.activeQuestsAdvancers.size():
			if (progression.activeQuestNameForAdvancers[i] == quest.questName && progression.activeQuestsAdvancers[i] > -1):
				quest.questStageAdvancers[progression.activeQuestsAdvancers[i]].queue_free()
		for i in progression.activeQuests.size():
			if (progression.activeQuests[i] == quest.questName):
				quest.AdvanceToStage(progression.activeQuestsStages[i])
				return

func SaveQuestProgressToPlayer(questName: String, questStage: int, questStageAdvancer: int):
	playerRef.playerProgressionTrack.RegisterQuestWithStage(questName, questStage)
	playerRef.playerProgressionTrack.RegisterAdvancers(questName, questStageAdvancer)
	CheckForUnlocksAfterQuest(questName, questStage)

func CheckForUnlocksAfterQuest(questName: String, questStage: int):
	for i in unlocksAfterQuestStages.size():
		if (questName == unlocksAfterQuestStages[i].requiredQuest):
			unlocksAfterQuestStages[i].CheckForCompletion(questStage)
			break

func SetCurrentKeysForPlayer():
	if (levelUnlockKeys.size() > 0):
		playerRef.playerProgressionTrack.GenerateCurrentIDArray(sceneType)
		var currentIDArray: Array[int] = playerRef.playerProgressionTrack.currentIDArray
		var currentUsedArray: Array[int] = playerRef.playerProgressionTrack.currentUsedKeysArray
		for i in currentIDArray.size():
			levelUnlockKeys[currentIDArray[i]].AlreadyGotThisKey()
			if (currentUsedArray[i] != -1):
				levelUnlockKeyDoors[currentUsedArray[i]].RegisterKey(currentIDArray[i])

func SetPlayerSpawn():
	if (playerRef.isTraveling):
		if (playerRef.positionalTraveling):
			playerRef.global_position = playerRef.positionalDestination
			return
		if (travelingReceivers.size() > 0):
			playerRef.global_position = travelingReceivers[playerRef.travelId].global_position
			return
	playerRef.global_position = playerSpawnPoint.global_position

func ActivateOrDeactivateFeedbackForLocalAllowedItems(transformationName: String, status: bool):
	for i in localAllowedItems.size():
		if (localAllowedItems[i].allowedObjects.has(transformationName)):
			if (status):
				localAllowedItems[i].ActivateFeedbacks()
			else:
				localAllowedItems[i].DeactivateFeedbacks()
