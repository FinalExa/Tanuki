extends Area2D

@export var dialogueText: Array[String]
@export var characterTalking: Array[DialogueUI.DialogueCharacters]
@export var characterEmotion: Array[DialogueUI.DialogueEmotions]
@export var deleteOnDone: bool

func _on_body_entered(body):
	if (body is PlayerCharacter):
		StartDialogue(body)

func StartDialogue(playerRef: PlayerCharacter):
	playerRef.playerHUD.ForcePause()
	playerRef.playerHUD.dialogueUI.StartNewDialogue(dialogueText, characterTalking, characterEmotion)
