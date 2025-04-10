class_name KeyCounter
extends Label

var sceneSelectorRef: SceneSelector
var playerProgressionRef: PlayerProgressionTrack

func _ready():
	sceneSelectorRef = get_tree().root.get_child(0).sceneSelector
	playerProgressionRef = get_parent().playerRef.playerProgressionTrack

func UpdateKeyCount():
	if (sceneSelectorRef.currentScene.levelUnlockKeys.size() > 0):
		var keyCount: int = 0
		for i in playerProgressionRef.unlockKeyIDs.size():
			if (playerProgressionRef.unlockKeyTypes[i] == sceneSelectorRef.currentScene.sceneType):
				keyCount += 1
		text = str("Keys: ", keyCount, "/", sceneSelectorRef.currentScene.levelUnlockKeys.size())
	else:
		text = ""
