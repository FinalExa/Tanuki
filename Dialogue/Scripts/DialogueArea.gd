class_name DialogueArea
extends Area2D

@export var dialogueText: Array[String]
@export var characterTalking: Array[DialogueUI.DialogueCharacters]
@export var characterEmotion: Array[DialogueUI.DialogueEmotions]
@export var deleteOnDone: bool
@export var savedOnDestroy: bool
@export var sceneMaster: SceneMaster

func _on_body_entered(body):
	if (body is PlayerCharacter):
		StartDialogue(body)

func StartDialogue(playerRef: PlayerCharacter):
	if (dialogueText.size() == characterTalking.size() && dialogueText.size() == characterEmotion.size() && dialogueText.size() > 0):
		playerRef.playerHUD.ForcePause()
		playerRef.playerHUD.dialogueUI.StartNewDialogue(dialogueText, characterTalking, characterEmotion, self)
		

func DeleteOnDone():
	if (deleteOnDone):
		SaveOnDestroy()
		get_parent().remove_child(self)

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

func ExecuteLoadOperation():
	get_parent().remove_child(self)
