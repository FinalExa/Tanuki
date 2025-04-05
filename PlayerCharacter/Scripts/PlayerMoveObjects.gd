class_name PlayerMoveObjects
extends Area2D

@export var playerCharacter: PlayerCharacter
@export var playerInputs: PlayerInputs
@export var transformationChange: TransformationChange
var objectsInRange: Array[MovableObject]
var currentObject: MovableObject

func _process(_delta):
	ObjectObtained()
	SelectObjectInRange()

func SelectObjectInRange():
	if (currentObject == null && objectsInRange.size() > 0 && !transformationChange.isTransformed && playerInputs.interactInput):
		currentObject = objectsInRange[GetMovableObject()]
		currentObject.AttachToPlayer(self)
		currentObject.TurnBothFeedbacksOff()

func GetMovableObject():
	var minDist: float
	var minDistIndex: int = 0
	for i in objectsInRange.size():
		var currentDistance: float = objectsInRange[i].global_position.distance_to(playerCharacter.global_position)
		if (i == 0):
			minDist = currentDistance
			continue
		if (objectsInRange[i].global_position.distance_to(playerCharacter.global_position) < minDist):
			minDist = currentDistance
			minDistIndex = i
	return minDistIndex

func ObjectObtained():
	if (currentObject != null):
		if (transformationChange.isTransformed || playerInputs.interactInput):
			DropMovableObject()

func DropMovableObject():
	if (currentObject != null):
		currentObject.ResetParent()
		currentObject = null

func ForceDropMovableObject():
	if (currentObject != null):
		currentObject.ResetParentAndPosition()
		currentObject = null

func DeleteLeftoverObject():
	if (currentObject != null):
		currentObject.queue_free()

func _on_area_entered(area):
	if (area is MovableObject && !objectsInRange.has(area)):
		objectsInRange.push_back(area)
		area.TurnCloseFeedbackOn(currentObject)

func _on_area_exited(area):
	if (area is MovableObject && objectsInRange.has(area)):
		objectsInRange.erase(area)
		area.TurnCloseFeedbackOff(currentObject)
