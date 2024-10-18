class_name SceneSelector
extends Node2D

@export var playerRef: PlayerCharacter
@export var safePosition: Vector2
@export var sceneMaster: SceneMaster
@export var deleteICD: float
var deleteTimer: float
var deleteActive: bool
var currentScenePath: String
var currentScene: GameplayScene

func _process(delta):
	ContinueAfterDelete(delta)

func ChangeScene(newPath: String):
	SetPlayerDataOnReload()
	currentScenePath = newPath
	DeleteCurrentScene(currentScene)

func DeleteCurrentScene(sceneToDelete: GameplayScene):
	if (sceneToDelete != null):
		remove_child(sceneToDelete)
		sceneToDelete.queue_free()
		sceneToDelete = null
	deleteTimer = deleteICD
	deleteActive = true


func ContinueAfterDelete(delta):
	if (deleteActive):
		if (deleteTimer > 0):
			deleteTimer -= delta
			return
		deleteActive = false
		InstantiateNewScene()

func SetPlayerDataOnReload():
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.transformationChangeRef.DeactivateTransformation()
	playerRef.transformationChangeRef.transformationTimer = 0
	playerRef.playerMovement.SetToZero()
	playerRef.global_position = safePosition
	playerRef.playerAttack.ForceStopAttack()

func InstantiateNewScene():
	var obj_scene = load(currentScenePath)
	var obj = obj_scene.instantiate()
	currentScene = obj
	add_child(currentScene)
	sceneMaster.UpdatePathAndLoad()
	currentScene.SetPlayerSpawn(playerRef)
	currentScene.SetCurrentKeysForPlayer(playerRef)

func ReloadScene():
	ChangeScene(currentScenePath)
