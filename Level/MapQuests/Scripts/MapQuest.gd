class_name MapQuest
extends Node2D

var gameplayScene: GameplayScene
@export var questName: String

@export var questItemsToOperate: Array[Node2D]
@export var questItemsStages: Array[int]
@export var questItemsOnOffState: Array[bool]
@export var questStageAdvancers: Array[Node2D]
@export var objectsToDeleteAtQuestComplete: Array[Node2D]

var advancedBy: Node2D
var currentQuestStage: int = 0
var lastStage: int

func SetLastStage():
	lastStage = questItemsStages[questItemsStages.size() - 1] + 1

func ExecuteCurrentStage(save: bool):
	SaveQuestStatus(save)
	if (currentQuestStage < lastStage):
		for i in questItemsStages.size():
			if (questItemsStages[i] == currentQuestStage):
				call_deferred("OnOff", questItemsToOperate[i], questItemsOnOffState[i])
				continue
			if (questItemsStages[i] > currentQuestStage):
				break
		SaveQuestStatus(save)
		CheckForLastStage()
		return

func SaveQuestStatus(save: bool):
	if (save):
		gameplayScene.SaveQuestProgressToPlayer(questName, currentQuestStage, GetStageAdvancerIndex())

func GetStageAdvancerIndex():
	if (advancedBy != null):
		if (questStageAdvancers.has(advancedBy)):
			var result: int = questStageAdvancers.find(advancedBy)
			advancedBy = null
			return result
		advancedBy = null
	return -1

func CheckForLastStage():
	if (currentQuestStage + 1 == lastStage):
		currentQuestStage = lastStage
		SaveQuestStatus(true)
		CleanUpAfterQuestComplete()

func CleanUpAfterQuestComplete():
	for i in objectsToDeleteAtQuestComplete.size():
		if (objectsToDeleteAtQuestComplete[i] != null):
			objectsToDeleteAtQuestComplete[i].queue_free()

func AdvanceStage(save: bool):
	if (currentQuestStage < lastStage):
		currentQuestStage += 1
		ExecuteCurrentStage(save)

func AdvanceStageByObject(objectRef: Node2D):
	if (currentQuestStage < lastStage):
		advancedBy = objectRef
		currentQuestStage += 1
		ExecuteCurrentStage(true)

func AdvanceToStage(stageToAdvance: int):
	if (stageToAdvance > lastStage):
		stageToAdvance = lastStage
	while (currentQuestStage < stageToAdvance):
		AdvanceStage(false)

func OnOff(objectToOperate: Node2D, status: bool):
	if (objectToOperate != null):
		if (status):
			self.add_child(objectToOperate)
			return
		if (objectToOperate.get_parent() != null):
			objectToOperate.get_parent().remove_child(objectToOperate)
