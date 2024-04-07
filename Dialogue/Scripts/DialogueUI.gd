class_name DialogueUI
extends Control

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

func StartNewDialogue(text: Array[String], characters: Array[DialogueCharacters], emotions: Array[DialogueEmotions]):
	currentDialogueText = text
	currentCharacterTalking = characters
	currentCharacterEmotion = emotions
	self.show()
