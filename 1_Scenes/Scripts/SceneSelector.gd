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
	playerRef.playerMovement.SetToZero()
	playerRef.global_position = safePosition
	playerRef.playerAttack.ForceStopAttack()
	playerRef.playerSubstitutionAttack.ForceStopAttack()
	playerRef.playerSubstitutionAttack.SetStartingSubstitutionStacks()

func InstantiateNewScene():
	var obj_scene = load(currentScenePath)
	var obj = obj_scene.instantiate()
	currentScene = obj
	add_child(currentScene)
	ClearTrash()
	sceneMaster.UpdatePathAndLoad()
	currentScene.Initialize()
	currentScene.SetPlayerSpawn()
	playerRef.UnsetTraveling()
	currentScene.SetCurrentKeysForPlayer()
	playerRef.playerHUD.keyCounter.UpdateKeyCount()

func ClearTrash():
	for i in self.get_child_count():
		if (self.get_child(i) != currentScene):
			self.get_child(0).queue_free()
	var root = sceneMaster.get_parent()
	for i in root.get_child_count():
		if (root.get_child(i) != sceneMaster):
			root.get_child(i).queue_free()

func ReloadScene():
	playerRef.transformationChangeRef.transformationTimer = 0
	playerRef.playerHUD.timerBar.UpdateTimer(playerRef.transformationChangeRef.transformationTimer, playerRef.transformationChangeRef.transformationDuration)
	ChangeScene(currentScenePath)
