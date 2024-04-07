class_name DialogueUI
extends Control

@export var charactersPerSecond: float
@export var leftSprite: Sprite2D
@export var rightSprite: Sprite2D
@export var dialogueText: TextEdit
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
var currentString: String
var currentIndex: int

func  _ready():
	dialogueIntervalBetweenCharacters = 1 / charactersPerSecond

func StartNewDialogue(text: Array[String], characters: Array[DialogueCharacters], emotions: Array[DialogueEmotions]):
	currentDialogueText = text
	currentCharacterTalking = characters
	currentCharacterEmotion = emotions
	currentIndex = 0
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
	currentTextLenght = currentDialogueText[currentIndex].length()
	if (currentCharacterTalking[currentIndex] == DialogueCharacters.DAICHI):
		leftSprite.show()
		rightSprite.hide()
	else:
		leftSprite.hide()
		rightSprite.show()

func WaitForContinue():
	if (Input.is_action_just_pressed("attack")):
		currentTextIndex += 1
		if (currentTextIndex >= currentDialogueText.size()):
			EndDialogue()
		else:
			SetCurrentText()

func EndDialogue():
	dialogueActive = false
	self.hide()
	playerHUD.EndForcePause()
