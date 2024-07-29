class_name SceneSelector
extends Node2D

@export var playerRef: PlayerCharacter
@export var safePosition: Vector2
var currentScene: GameplayScene

func ChangeScene(newPath: String):
	playerRef.global_position = safePosition
	if (currentScene != null):
		remove_child(currentScene)
		currentScene.queue_free()
		currentScene = null
	var obj_scene = load(newPath)
	var obj = obj_scene.instantiate()
	currentScene = obj
	add_child(currentScene)
	currentScene.SetPlayerSpawn(playerRef)
	playerRef.playerMovement.SetToZero()
