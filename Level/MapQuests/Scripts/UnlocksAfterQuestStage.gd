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
			if (objectsToAdd[i] != null && objectsToAdd[i].get_parent() != null):
				objectsToAdd[i].get_parent().remove_child(objectsToAdd[i])

func CheckForCompletion(questStage: int):
	if (questStage >= requiredQuestStage):
		CompleteUnlockAfterQuest()

func CompleteUnlockAfterQuest():
	if (objectsToAdd.size() > 0):
		for i in objectsToAdd.size():
			if (objectsToAdd[i] != null):
				self.add_child(objectsToAdd[i])
	if (objectsToRemove.size() > 0):
		for i in objectsToRemove.size():
			if (objectsToRemove[i] != null):
				objectsToRemove[i].queue_free()
