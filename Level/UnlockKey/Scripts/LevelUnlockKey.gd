class_name LevelUnlockKey
extends Area2D

var gameplayScene: GameplayScene

func _on_body_entered(body):
	if (body is PlayerCharacter):
		PlayerGotKey(body)

func PlayerGotKey(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.RegisterKey(FindID())
	queue_free()

func FindID():
	for i in gameplayScene.levelUnlockKeys.size():
		if (gameplayScene.levelUnlockKeys[i] == self): return i

func AlreadyGotThisKey():
	queue_free()
