class_name KeyCounter
extends Label

var sceneSelectorRef: SceneSelector
var playerProgressionRef: PlayerProgressionTrack

func _ready():
	sceneSelectorRef = get_tree().root.get_child(0).sceneSelector
	playerProgressionRef = get_parent().playerRef.playerProgressionTrack

func UpdateKeyCount():
	if (sceneSelectorRef.currentScene.levelUnlockKeys.size() > 0):
		text = str("Keys: ", playerProgressionRef.unlockKeyIDs.size(), "/", sceneSelectorRef.currentScene.levelUnlockKeys.size())
	else:
		text = ""
