class_name LevelUnlockKey
extends Area2D

var gameplayScene: GameplayScene
@export var keyAdvancesQuest: bool
@export var questToAdvance: MapQuest

func _on_body_entered(body):
	if (body is PlayerCharacter):
		PlayerGotKey(body)

func PlayerGotKey(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.RegisterKey(FindID())
	if (keyAdvancesQuest && questToAdvance != null):
		questToAdvance.AdvanceStage(false, false)
	queue_free()

func FindID():
	for i in gameplayScene.levelUnlockKeys.size():
		if (gameplayScene.levelUnlockKeys[i] == self): return i

func AlreadyGotThisKey():
	queue_free()
