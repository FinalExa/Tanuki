class_name DoorOpenCloseHitbox
extends Area2D

@export var refDoor: DoorOpenClose
var entitiesInArea: Array[Node2D]

func _process(_delta):
	OpenClose()

func OpenClose():
	if (refDoor != null):
		if (entitiesInArea.size() > 0 && !refDoor.opened):
			refDoor.OpenDoor()
			return
		if (entitiesInArea.size() == 0 && refDoor.opened):
			refDoor.CloseDoor()

func CheckForEntityIn(ref):
	if (ref is PlayerCharacter || ref is EnemyController):
		if (!entitiesInArea.has(ref)):
			entitiesInArea.push_back(ref)

func CheckForEntityOut(ref):
	if (ref is PlayerCharacter || ref is EnemyController):
		if (entitiesInArea.has(ref)):
			entitiesInArea.erase(ref)
