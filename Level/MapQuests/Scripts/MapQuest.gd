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

func ExecuteCurrentStage(save: bool, forcedAdvance: bool):
	SaveQuestStatus(save)
	if (currentQuestStage < lastStage):
		for i in questItemsStages.size():
			if (forcedAdvance && questItemsToOperate[i] is DialogueArea):
				questItemsToOperate[i].queue_free()
				continue
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

func AdvanceStage(save: bool, forcedAdvance: bool):
	if (currentQuestStage < lastStage):
		currentQuestStage += 1
		ExecuteCurrentStage(save, forcedAdvance)

func AdvanceStageByObject(objectRef: Node2D):
	if (currentQuestStage < lastStage):
		advancedBy = objectRef
		currentQuestStage += 1
		ExecuteCurrentStage(true, false)

func AdvanceToStage(stageToAdvance: int):
	if (stageToAdvance > lastStage):
		stageToAdvance = lastStage
	while (currentQuestStage < stageToAdvance):
		AdvanceStage(false, true)

func OnOff(objectToOperate: Node2D, status: bool):
	if (objectToOperate != null):
		if (status):
			ActivateObjectToOperate(objectToOperate)
			return
		DeactivateObjectToOperate(objectToOperate)

func ActivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Activation()
		return
	objectToOperate.show()
	objectToOperate.set_process(true)
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = false
	if (objectToOperate is DialogueArea):
		objectToOperate.ActivatedByQuest()

func DeactivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Deactivation()
		return
	objectToOperate.hide()
	objectToOperate.set_process(false)
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = true
