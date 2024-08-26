extends PuzzleObject

@export var heatSourceRef: Node2D

func Activation():
	if (heatSourceRef.get_parent() == null):
		call_deferred("AddChild")

func Deactivation():
	call_deferred("RemoveChild")

func AddChild():
	self.add_child(heatSourceRef)

func RemoveChild():
	self.remove_child(heatSourceRef)
