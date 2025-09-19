class_name SceneMaster
extends Node2D

var savePath: String
var playerDataSavePath: String = "user://saves/PlayerData.save"
var stopResetPosition: bool

var lastPos: Vector2
var lastTransformationSet: bool
var lastObjectOriginalPath: String

@export var frameMaster: FrameMaster
@export var sceneSelector: SceneSelector
@export var playerRef: PlayerCharacter
var oneTimeSavePoints: Array[String]
var isInGameplayScene: bool
var currentlyLoadedGameplayScene: String

var loadActive: bool
var hasLoaded: bool

func _ready():
	playerRef.playerHUD.loadingScreen.show()
	playerRef.playerInputs.inputsForceLocked = true
	loadActive = true
	hasLoaded = false
	if (get_tree().paused):
		get_tree().paused = false

func UpdatePathAndLoad():
	savePath = "user://saves/" + sceneSelector.currentScene.name + ".save"
	if (loadActive):
		Load()
		loadActive = false
		hasLoaded = true

func Save():
	CheckForFolder()
	SaveMapData(FileAccess.open(savePath, FileAccess.WRITE), "")
	SavePlayerData(FileAccess.open(playerDataSavePath, FileAccess.WRITE))

func SaveAndDeleteOneTimeSave(oneTimeSavePath: String):
	CheckForFolder()
	SaveMapData(FileAccess.open(savePath, FileAccess.WRITE), oneTimeSavePath)
	SavePlayerData(FileAccess.open(playerDataSavePath, FileAccess.WRITE))

func CheckForFolder():
	if (!DirAccess.dir_exists_absolute("user://saves")):
		var dir = DirAccess.open("user://")
		dir.make_dir("saves")

func SaveMapData(file, oneTimeSavePath: String):
	file.store_var(playerRef.global_position)
	if (oneTimeSavePath != ""):
		oneTimeSavePoints.push_back(oneTimeSavePath)
	file.store_var(oneTimeSavePoints)

func SavePlayerData(file):
	file.store_var(playerRef.currentScenePath)
	file.store_var(playerRef.transformationChangeRef.currentTransformationSet)
	file.store_var(playerRef.transformationChangeRef.currentOriginalObjectPath)
	file.store_var(playerRef.playerProgressionTrack.unlockKeyTypes)
	file.store_var(playerRef.playerProgressionTrack.unlockKeyIDs)
	file.store_var(playerRef.playerProgressionTrack.usedUnlockKeyForDoors)
	file.store_var(playerRef.playerProgressionTrack.specialUnlockKeysObtained)
	file.store_var(playerRef.playerProgressionTrack.purifiedUnlockKeysObtained)
	file.store_var(playerRef.playerProgressionTrack.obtainedUpgrades)
	file.store_var(playerRef.playerProgressionTrack.activeQuests)
	file.store_var(playerRef.playerProgressionTrack.activeQuestsStages)
	file.store_var(playerRef.playerProgressionTrack.activeQuestNameForAdvancers)
	file.store_var(playerRef.playerProgressionTrack.activeQuestsAdvancers)

func Load():
	LoadPlayerData()
	LoadMapData()
	LoadOperations()

func LoadMapData():
	if (FileAccess.file_exists(savePath)):
		var file = FileAccess.open(savePath, FileAccess.READ)
		lastPos = file.get_var()
		DestroyOneTimeSavePoints(file.get_var())
		stopResetPosition = false
	else:
		stopResetPosition = true

func DestroyOneTimeSavePoints(array: Array):
	oneTimeSavePoints.clear()
	for i in array.size():
		oneTimeSavePoints.push_back(array[i])
	if (oneTimeSavePoints.size() > 0):
		for i in oneTimeSavePoints.size():
			var node = get_node_or_null(oneTimeSavePoints[i])
			if (node != null): node.queue_free()

func LoadPlayerData():
	playerRef.playerProgressionTrack.ClearAll()
	if (FileAccess.file_exists(playerDataSavePath)):
		var file = FileAccess.open(playerDataSavePath, FileAccess.READ)
		playerRef.currentScenePath = file.get_var()
		lastTransformationSet = file.get_var()
		lastObjectOriginalPath = file.get_var()
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.unlockKeyTypes)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.unlockKeyIDs)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.usedUnlockKeyForDoors)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.specialUnlockKeysObtained)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.purifiedUnlockKeysObtained)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.obtainedUpgrades)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.activeQuests)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.activeQuestsStages)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.activeQuestNameForAdvancers)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.activeQuestsAdvancers)

func ExtractArray(result, currentArray):
	currentArray.clear()
	if (result != null):
		for i in result.size():
			currentArray.push_back(result[i])
	return currentArray

func LoadOperations():
	if (!stopResetPosition):
		playerRef.global_position = lastPos
	if (lastTransformationSet):
		var new_trs_scene = load(lastObjectOriginalPath)
		var new_trs: TransformationObjectData = new_trs_scene.instantiate()
		new_trs.GetScale()
		playerRef.transformationChangeRef.transformationSaving.SaveNewTransformation(new_trs)
	else:
		playerRef.transformationChangeRef.SetNoTransformation()
	playerRef.playerHUD.emit_signal("has_attack", true)
	playerRef.playerAttack.ResetCooldownUpgrade()
	playerRef.transformationChangeRef.ResetUpgradeDuration()
	playerRef.playerHealth.ResetMaxHealth()
	playerRef.playerRoll.ResetUpgrades()
	playerRef.playerProgressionTrack.ActivateUpgrades()
