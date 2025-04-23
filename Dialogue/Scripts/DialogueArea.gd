class_name DialogueArea
extends Area2D

@export var dialogueExecutingICD: float
@export var dialogueText: Array[String]
@export var characterTalking: Array[DialogueUI.DialogueCharacters]
@export var characterEmotion: Array[DialogueUI.DialogueEmotions]
@export var cameraFocuses: Array[Node2D]
@export var isOnInteraction: bool
@export var interactionLabel: Label
@export var labelDefaultText: String = "PRESS SHIFT TO TALK"
@export var deleteOnDone: bool
@export var advanceQuest: bool
@export var questRef: MapQuest
@export var activatedByQuest: bool
var dialogueExecutingTimer: float
var dialogueExecutingCooldownActive: bool
var dialogueExecuting: bool
var player: PlayerCharacter

func _ready():
	interactionLabel.text = labelDefaultText
	interactionLabel.hide()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		PlayerEntered(body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		PlayerExited()

func _process(delta):
	DialogueExecutingICD(delta)
	PlayerIn()

func PlayerEntered(playerCharacter: PlayerCharacter):
	player = playerCharacter
	if (isOnInteraction):
		interactionLabel.show()

func PlayerExited():
	interactionLabel.hide()
	player = null
	if (!isOnInteraction):
		StartDialogueExecutingICD()

func PlayerIn():
	if (player != null && !dialogueExecuting):
		if (isOnInteraction):
			if (player.playerInputs.interactInput):
				player.playerInputs.interactInput = false
				StartDialogue(player)
			return
		StartDialogue(player)

func StartDialogue(playerRef: PlayerCharacter):
	if (dialogueText.size() == characterTalking.size() && dialogueText.size() == characterEmotion.size() && dialogueText.size() == cameraFocuses.size() && dialogueText.size() > 0):
		playerRef.playerHUD.ForcePause()
		playerRef.playerHUD.dialogueUI.StartNewDialogue(dialogueText, characterTalking, characterEmotion, cameraFocuses, self)
		dialogueExecuting = true

func DialogueDone():
	if (advanceQuest && questRef != null):
		questRef.AdvanceStageByObject(self)
	if (deleteOnDone):
		queue_free()
	if (isOnInteraction):
		dialogueExecuting = false

func StartDialogueExecutingICD():
	dialogueExecutingCooldownActive = true
	dialogueExecutingTimer = dialogueExecutingICD

func DialogueExecutingICD(delta):
	if (dialogueExecutingCooldownActive):
		if (dialogueExecutingTimer > 0):
			dialogueExecutingTimer -= delta
			return
		dialogueExecuting = false
		dialogueExecutingCooldownActive = false

func Activation():
	self.show()
	self.set_process(true)
	for i in self.get_child_count():
		if (self.get_child(i) is CollisionShape2D):
			self.get_child(i).disabled = false
			break

func Deactivation():
	self.hide()
	self.set_process(false)
	for i in self.get_child_count():
		if (self.get_child(i) is CollisionShape2D):
			self.get_child(i).disabled = true

func ActivatedByQuest():
	if (activatedByQuest):
		var playerRef: PlayerCharacter = get_tree().root.get_child(0).playerRef
		StartDialogue(playerRef)
