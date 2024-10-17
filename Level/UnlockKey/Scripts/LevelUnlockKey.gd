class_name LevelUnlockKey
extends Area2D

var gameplayScene: GameplayScene
var sourceType: GameplayScene.SceneType
@export var sourceObject: Node2D

func _on_body_entered(body):
	if (body is PlayerCharacter):
		pass
