class_name SpecialUnlockKey
extends LevelUnlockKey

@export var purified: bool

func PlayerGotKey(playerRef: PlayerCharacter):
	if (!purified):
		playerRef.playerProgressionTrack.RegisterSpecialKey(gameplayScene.sceneType)
	else:
		playerRef.playerProgressionTrack.RegisterPurifiedKey(gameplayScene.sceneType)
	if (keyAdvancesQuest && questToAdvance != null):
		questToAdvance.AdvanceStage(false, false)
	queue_free()

func FindID():
	return gameplayScene.sceneType
