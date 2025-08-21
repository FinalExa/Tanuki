class_name DialogueIndex
extends Resource

@export var dialogueText: String
@export var characterTalking: DialogueUI.DialogueCharacters
@export var cameraFocus: NodePath

func GetCameraFocus(dialogueArea: DialogueArea):
	return dialogueArea.get_node_or_null(cameraFocus)

func SetPath(dialogueArea: DialogueArea, nodeRef: Node2D):
	return dialogueArea.get_path_to(nodeRef)
