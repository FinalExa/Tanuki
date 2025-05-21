class_name KeyCounter
extends Label

var sceneSelectorRef: SceneSelector
var playerProgressionRef: PlayerProgressionTrack
@export var keysText: String
@export var specialKeyText: String

func _ready():
	sceneSelectorRef = get_tree().root.get_child(0).sceneSelector
	playerProgressionRef = get_parent().playerRef.playerProgressionTrack

func UpdateKeyCount():
	if (playerProgressionRef.unlockKeyTypes.size() > 0):
		var keyCount: int = 0
		for i in playerProgressionRef.unlockKeyIDs.size():
			if (playerProgressionRef.unlockKeyTypes[i] == sceneSelectorRef.currentScene.keyTypeToShow):
				keyCount += 1
		if (keyCount > 0):
			text = str(keysText, keyCount, GetSpecialKeyCount())
			return
		text = str("", GetSpecialKeyCount())

func GetSpecialKeyCount():
	if (playerProgressionRef.specialUnlockKeysObtained.has(sceneSelectorRef.currentScene.sceneType)):
		return str("\n" ,specialKeyText)
	return ""
