class_name GenericInteractable
extends Node2D

@export var neededString: String
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
var sceneMaster: SceneMaster

func attackInteraction(receivedString):
	if (neededString == receivedString):
		ExecuteExtraEffect()
		SaveOnDestroy()
		get_parent().remove_child(self)

func ExecuteExtraEffect():
	pass

func SaveOnDestroy():
	if (savedOnDestroy):
		var savedPath: String
		savedPath = ComposePathString(SetCurrentNodeInPath(self))
		sceneMaster.AddDeletePath(savedPath)

func SetCurrentNodeInPath(node: Node2D):
	var path: Array[String] = []
	path.push_front(node.name)
	var reached: bool = false
	while (!reached):
		node = node.get_parent()
		path.push_front(node.name)
		if (node is SceneMaster):
			sceneMaster = node
			reached = true
	return path

func ComposePathString(path: Array[String]):
	var pathString: String = ""
	for i in path.size():
		pathString += path[i] + "/"
	return pathString

func SaveDestroySignalToOtherObject():
	if (objectToSendDestoySignal != null):
		objectToSendDestoySignal.DestroyedSignal()
