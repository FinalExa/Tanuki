class_name SceneSelector
extends Node2D

@export var playerRef: PlayerCharacter
@export var safePosition: Vector2
@export var sceneMaster: SceneMaster
var currentScenePath: String
var currentScene: GameplayScene

func ChangeScene(newPath: String):
	playerRef.playerMovement.SetToZero()
	playerRef.global_position = safePosition
	if (currentScene != null):
		remove_child(currentScene)
		currentScene.free()
		currentScene = null
	currentScenePath = newPath
	var obj_scene = load(currentScenePath)
	var obj = obj_scene.instantiate()
	currentScene = obj
	add_child(currentScene)
	currentScene.SetPlayerSpawn(playerRef)
	sceneMaster.UpdatePathAndLoad()

func ReloadScene():
	ChangeScene(currentScenePath)
