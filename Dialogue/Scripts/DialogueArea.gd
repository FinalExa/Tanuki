class_name DialogueArea
extends Area2D

@export var dialogueText: Array[String]
@export var characterTalking: Array[DialogueUI.DialogueCharacters]
@export var characterEmotion: Array[DialogueUI.DialogueEmotions]
@export var deleteOnDone: bool
@export var savedOnDestroy: bool
@export var sceneMaster: SceneMaster

func _ready():
	sceneMaster = get_tree().root.get_child(0)

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
		queue_free()

func SaveOnDestroy():
	if (savedOnDestroy):
		sceneMaster.AddPathString(self)

func ExecuteLoadOperation():
	queue_free()
