class_name DialogueArea
extends Area2D

@export var dialogueText: Array[String]
@export var characterTalking: Array[DialogueUI.DialogueCharacters]
@export var characterEmotion: Array[DialogueUI.DialogueEmotions]
@export var cameraFocuses: Array[Node2D]
@export var isOnInteraction: bool
@export var interactionLabel: Label
@export var deleteOnDone: bool
var dialogueExecuting: bool
var player: PlayerCharacter

func _ready():
	interactionLabel.hide()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		PlayerEntered(body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		PlayerExited()

func _process(_delta):
	PlayerIn()

func PlayerEntered(playerCharacter: PlayerCharacter):
	if (isOnInteraction):
		interactionLabel.show()
		player = playerCharacter
		return
	StartDialogue(playerCharacter)

func PlayerExited():
	interactionLabel.hide()
	if (isOnInteraction):
		player = null

func PlayerIn():
	if (player != null && !dialogueExecuting):
		if (player.playerInputs.interactInput):
			player.playerInputs.interactInput = false
			StartDialogue(player)
			return

func StartDialogue(playerRef: PlayerCharacter):
	if (dialogueText.size() == characterTalking.size() && dialogueText.size() == characterEmotion.size() && dialogueText.size() == cameraFocuses.size() && dialogueText.size() > 0):
		playerRef.playerHUD.ForcePause()
		playerRef.playerHUD.dialogueUI.StartNewDialogue(dialogueText, characterTalking, characterEmotion, cameraFocuses, self)
		dialogueExecuting = true

func DialogueDone():
	dialogueExecuting = false
	if (deleteOnDone):
		queue_free()
