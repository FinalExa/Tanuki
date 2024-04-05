extends GenericInteractable

@export var dropActive: bool
@export var droppedObjectOnInteraction: String
@export var dropPoint: Node2D

func ExecuteExtraEffect():
	if (dropActive && droppedObjectOnInteraction != ""):
		var obj_scene = load(droppedObjectOnInteraction)
		var obj = obj_scene.instantiate()
		get_parent().add_child(obj)
		for i in get_parent().get_child_count():
			if (get_parent().get_child(i) == obj):
				get_parent().get_child(i).global_position = dropPoint.global_position
