class_name UnlocksAfterQuestStage
extends Node2D


@export var requiredQuest: String
@export var requiredQuestStage: int

@export var objectsToAdd: Array[Node2D]
@export var objectsToRemove: Array[Node2D]

func _ready():
	RemoveObjectsToAddAtStart()

func RemoveObjectsToAddAtStart():
	if (objectsToAdd.size() > 0):
		for i in objectsToAdd.size():
			if (objectsToAdd[i] != null):
				DeactivateObjectToOperate(objectsToAdd[i])

func CheckForCompletion(questStage: int):
	if (questStage >= requiredQuestStage):
		CompleteUnlockAfterQuest()

func CompleteUnlockAfterQuest():
	if (objectsToAdd.size() > 0):
		for i in objectsToAdd.size():
			if (objectsToAdd[i] != null):
				if (objectsToAdd[i] is PuzzleObject):
					objectsToAdd[i].InteractSignal()
				else:
					ActivateObjectToOperate(objectsToAdd[i])
	if (objectsToRemove.size() > 0):
		for i in objectsToRemove.size():
			if (objectsToRemove[i] != null):
				DeactivateObjectToOperate(objectsToRemove[i])

func ActivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Activation()
		return
	objectToOperate.show()
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = false

func DeactivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Deactivation()
		return
	objectToOperate.hide()
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = true
