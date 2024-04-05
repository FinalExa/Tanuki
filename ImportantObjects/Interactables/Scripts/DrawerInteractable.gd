extends GenericInteractable

@export var droppedObjectOnInteraction: String

func ExecuteExtraEffect():
	if (droppedObjectOnInteraction != ""):
		var obj_scene = load(droppedObjectOnInteraction)
		var obj = obj_scene.instantiate()
		get_parent().add_child(obj)
	print("done")
