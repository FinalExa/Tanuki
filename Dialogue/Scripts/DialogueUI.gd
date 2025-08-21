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
	OTHER
}

var currentDialogueIndexes: Array[DialogueIndex]
var currentString: String
var currentIndex: int
var currentSource: DialogueArea

func _ready():
	dialogueIntervalBetweenCharacters = 1 / charactersPerSecond
	leftSprite.play("default")
	rightSprite.play("default")

func _process(delta):
	ExecuteDialogue(delta)

func StartNewDialogueWithIndex(indexArray: Array[DialogueIndex], source: DialogueArea):
	for i in indexArray.size():
		currentDialogueIndexes.push_back(CreateIndex(indexArray[i].dialogueText, indexArray[i].characterTalking, indexArray[i].cameraFocus))
	currentIndex = 0
	currentSource = source
	SetCurrentText()
	self.show()
	dialogueActive = true

func CreateIndex(text: String, character: DialogueCharacters, focus: NodePath):
	var dialogueIndex: DialogueIndex = DialogueIndex.new()
	dialogueIndex.dialogueText = text
	dialogueIndex.characterTalking = character
	dialogueIndex.cameraFocus = focus
	return dialogueIndex

func StartNewDialogue(text: Array[String], characters: Array[DialogueCharacters], focus: Array[Node2D], source: DialogueArea):
	for i in text.size():
		currentDialogueIndexes.push_back(CreateIndexOld(text[i], characters[i], focus[i], source))
	currentIndex = 0
	currentSource = source
	SetCurrentText()
	self.show()
	dialogueActive = true

func CreateIndexOld(text: String, character: DialogueCharacters, focus: Node2D, source: DialogueArea):
	var dialogueIndex: DialogueIndex = DialogueIndex.new()
	dialogueIndex.dialogueText = text
	dialogueIndex.characterTalking = character
	dialogueIndex.cameraFocus = dialogueIndex.SetPath(source, focus)
	return dialogueIndex

func ExecuteDialogue(delta):
	if (dialogueActive):
		if (!dialogueDoneShowing):
			ProgressivelyShowDialogue(delta)
		else:
			WaitForContinue()

func ProgressivelyShowDialogue(delta):
	if (Input.is_action_just_pressed("attack")):
		dialogueText.text = currentDialogueIndexes[currentIndex].dialogueText
		dialogueDoneShowing = true
		return
	if (currentString != currentDialogueIndexes[currentIndex].dialogueText):
		if (currentTextIndex < currentTextLenght):
			if (internalTimer < dialogueIntervalBetweenCharacters):
				internalTimer += delta
			else:
				AdvanceTextIndex()
	else:
		dialogueDoneShowing = true

func AdvanceTextIndex():
	internalTimer -= dialogueIntervalBetweenCharacters
	currentString += currentDialogueIndexes[currentIndex].dialogueText[currentTextIndex]
	currentTextIndex += 1
	dialogueText.text = currentString
	if (internalTimer >= dialogueIntervalBetweenCharacters):
		AdvanceTextIndex()

func SetCurrentText():
	currentString = ""
	internalTimer = 0
	dialogueDoneShowing = false
	currentTextIndex = 0
	var focus: Node2D = currentDialogueIndexes[currentIndex].GetCameraFocus(currentSource)
	if (focus != null): playerHUD.playerRef.cameraRef.SetNewCameraTarget(focus)
	else: playerHUD.playerRef.cameraRef.ResetToPlayer()
	currentTextLenght = currentDialogueIndexes[currentIndex].dialogueText.length()
	if (currentDialogueIndexes[currentIndex].characterTalking == DialogueCharacters.DAICHI):
		leftSprite.show()
		rightSprite.hide()
	else:
		leftSprite.hide()
		rightSprite.show()

func WaitForContinue():
	if (Input.is_action_just_pressed("attack")):
		currentIndex += 1
		if (currentIndex >= currentDialogueIndexes.size()):
			EndDialogue()
		else:
			SetCurrentText()

func EndDialogue():
	dialogueActive = false
	playerHUD.playerRef.cameraRef.ResetToPlayer()
	self.hide()
	dialogueText.text = ""
	currentDialogueIndexes.clear()
	currentSource.DialogueDone()
	playerHUD.EndForcePause()
