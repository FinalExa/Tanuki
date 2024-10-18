class_name MapQuest
extends Node2D

var gameplayScene: GameplayScene
@export var questName: String

@export var questItemsToOperate: Array[Node2D]
@export var questItemsStages: Array[int]
@export var questItemsOnOffState: Array[bool]
@export var objectsToDeleteAtQuestComplete: Array[Node2D]

var currentQuestStage: int = 0
var lastStage: int

func _ready():
	GetLastStage()
	ExecuteCurrentStage()

func GetLastStage():
	lastStage = questItemsStages[questItemsStages.size() - 1] + 1

func ExecuteCurrentStage():
	if (currentQuestStage < lastStage):
		for i in questItemsStages.size():
			if (questItemsStages[i] == currentQuestStage):
				
				OnOff(questItemsToOperate[i], questItemsOnOffState[i])
				continue
			if (questItemsStages[i] > currentQuestStage):
				break
		return
	for i in objectsToDeleteAtQuestComplete.size():
		if (objectsToDeleteAtQuestComplete[i] != null):
			objectsToDeleteAtQuestComplete[i].queue_free()

func AdvanceStage():
	if (currentQuestStage < lastStage):
		currentQuestStage += 1
		ExecuteCurrentStage()

func AdvanceToStage(stageToAdvance: int):
	if (stageToAdvance > lastStage):
		stageToAdvance = lastStage
	while (currentQuestStage < stageToAdvance):
		AdvanceStage()

func OnOff(objectToOperate: Node2D, status: bool):
	if (status):
		self.add_child(objectToOperate)
		return
	if (objectToOperate.get_parent() != null):
		objectToOperate.get_parent().remove_child(objectToOperate)
