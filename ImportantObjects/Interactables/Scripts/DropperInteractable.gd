class_name DropperInteractable
extends GenericInteractable

@export var dropActive: bool
@export var droppedObjectsOnInteraction: Array[String]
@export var dropPoints: Array[Node2D]

func ExecuteExtraEffect():
	if (dropActive && droppedObjectsOnInteraction.size() > 0):
		for i in droppedObjectsOnInteraction.size():
			if (droppedObjectsOnInteraction[i] != ""):
				var obj_scene = load(droppedObjectsOnInteraction[i])
				var obj = obj_scene.instantiate()
				parentRef.add_child(obj)
				obj.global_position = dropPoints[i].global_position

func DestroyedSignal():
	dropActive = false
