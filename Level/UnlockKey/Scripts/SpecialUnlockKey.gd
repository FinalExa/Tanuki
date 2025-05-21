class_name SpecialUnlockKey
extends LevelUnlockKey

func PlayerGotKey(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.RegisterSpecialKey(gameplayScene.sceneType)
	if (keyAdvancesQuest && questToAdvance != null):
		questToAdvance.AdvanceStage(false, false)
	queue_free()

func FindID():
	return gameplayScene.sceneType
