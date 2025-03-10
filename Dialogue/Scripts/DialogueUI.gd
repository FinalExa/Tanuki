class_name DialogueUI
extends Control

@export var charactersPerSecond: float
@export var leftSprite: AnimatedSprite2D
@export var rightSprite: AnimatedSprite2D
@export var dialogueText: Label
@export var playerHUD: PlayerHUD
var dialogueIntervalBetweenCharacters: float
var currentTextLenght: int
var currentTextIndex: int
var internalTimer: float
var dialogueActive: bool
var dialogueDoneShowing: bool

enum DialogueCharacters {
	DAICHI,
	GOZO,
	GUARD
}

enum DialogueEmotions {
	CALM,
	ANGRY,
	SAD,
	HAPPY
}

var currentDialogueText: Array[String]
var currentCharacterTalking: Array[DialogueCharacters]
var currentCharacterEmotion: Array[DialogueEmotions]
var currentCameraFocuses: Array[Node2D]
var currentString: String
var currentIndex: int
var currentSource: DialogueArea

func _ready():
	dialogueIntervalBetweenCharacters = 1 / charactersPerSecond
	leftSprite.play("default")
	rightSprite.play("default")

func StartNewDialogue(text: Array[String], characters: Array[DialogueCharacters], emotions: Array[DialogueEmotions], focus: Array[Node2D], source: DialogueArea):
	currentDialogueText = text
	currentCharacterTalking = characters
	currentCharacterEmotion = emotions
	currentCameraFocuses = focus
	currentIndex = 0
	currentSource = source
	SetCurrentText()
	self.show()
	dialogueActive = true

func _process(delta):
	ExecuteDialogue(delta)

func ExecuteDialogue(delta):
	if (dialogueActive):
		if (!dialogueDoneShowing):
			ProgressivelyShowDialogue(delta)
		else:
			WaitForContinue()

func ProgressivelyShowDialogue(delta):
	if (Input.is_action_just_pressed("attack")):
		dialogueText.text = currentDialogueText[currentIndex]
		dialogueDoneShowing = true
		return
	if (currentString != currentDialogueText[currentIndex]):
		if (currentTextIndex < currentTextLenght):
			if (internalTimer < dialogueIntervalBetweenCharacters):
				internalTimer += delta
			else:
				AdvanceTextIndex()
	else:
		dialogueDoneShowing = true

func AdvanceTextIndex():
	internalTimer -= dialogueIntervalBetweenCharacters
	currentString += currentDialogueText[currentIndex][currentTextIndex]
	currentTextIndex += 1
	dialogueText.text = currentString
	if (internalTimer >= dialogueIntervalBetweenCharacters):
		AdvanceTextIndex()

func SetCurrentText():
	currentString = ""
	internalTimer = 0
	dialogueDoneShowing = false
	currentTextIndex = 0
	if (currentCameraFocuses[currentIndex] != null): playerHUD.playerRef.cameraRef.SetNewCameraTarget(currentCameraFocuses[currentIndex])
	else: playerHUD.playerRef.cameraRef.ResetToPlayer()
	currentTextLenght = currentDialogueText[currentIndex].length()
	if (currentCharacterTalking[currentIndex] == DialogueCharacters.DAICHI):
		leftSprite.show()
		rightSprite.hide()
	else:
		leftSprite.hide()
		rightSprite.show()

func WaitForContinue():
	if (Input.is_action_just_pressed("attack")):
		currentIndex += 1
		if (currentIndex >= currentDialogueText.size()):
			EndDialogue()
		else:
			SetCurrentText()

func EndDialogue():
	dialogueActive = false
	playerHUD.playerRef.cameraRef.ResetToPlayer()
	self.hide()
	dialogueText.text = ""
	currentSource.DialogueDone()
	playerHUD.EndForcePause()
