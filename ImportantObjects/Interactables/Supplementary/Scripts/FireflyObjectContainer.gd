class_name FireflyObjectContainer
extends Area2D

@export var initialState: bool
@export var excludeArray: Array[Node2D]
var currentState: bool
var objectsToUpdateArray: Array[Node2D]

func _ready():
	currentState = initialState
	GenerateObjectArray()
	call_deferred("SetState")

func GenerateObjectArray():
	for i in self.get_child_count():
		if (!excludeArray.has(self.get_child(i))):
			objectsToUpdateArray.push_back(self.get_child(i))

func SwapState():
	currentState = !currentState
	call_deferred("SetState")

func SetState():
	if (objectsToUpdateArray.size() > 0):
		for i in objectsToUpdateArray.size():
			if (currentState):
				Activate(objectsToUpdateArray[i])
			else:
				Deactivate(objectsToUpdateArray[i])

func Activate(object: Node2D):
	if (object is DoorOpenClose):
		object.OpenDoor()
		return
	if (object is PuzzleObject):
		object.Activation()
		return
	if (object is TransformationObjectData || object is TrapObject):
		object.TurnOn()
	object.show()
	object.set_process(true)
	for i in object.get_child_count():
		if (object.get_child(i) is CollisionShape2D || object.get_child(i) is CollisionPolygon2D):
			object.get_child(i).disabled = false
		if (object.get_child(i) is DialogueArea):
			object.get_child(i).set_process(true)
	if (object is DialogueArea):
		object.ActivatedByQuest()

func Deactivate(object: Node2D):
	if (object is DoorOpenClose):
		object.CloseDoor()
		return
	if (object is PuzzleObject):
		object.Deactivation()
		return
	if (object is TransformationObjectData || object is TrapObject):
		object.TurnOff()
	object.hide()
	object.set_process(false)
	for i in object.get_child_count():
		if (object.get_child(i) is CollisionShape2D || object.get_child(i) is CollisionPolygon2D):
			object.get_child(i).disabled = true
		if (object.get_child(i) is DialogueArea):
			object.get_child(i).set_process(false)
