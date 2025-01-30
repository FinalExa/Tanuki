class_name SceneMaster
extends Node2D

var savePath: String
var playerDataSavePath: String = "user://PlayerData.save"
var stopResetPosition: bool

var lastPos: Vector2
var lastTransformationSet: bool
var lastObjectOriginalPath: String

@export var frameMaster: FrameMaster
@export var sceneSelector: SceneSelector
@export var playerRef: PlayerCharacter
var isInGameplayScene: bool
var currentlyLoadedGameplayScene: String

var loadActive: bool

func _ready():
	loadActive = true
	if (get_tree().paused):
		get_tree().paused = false

func UpdatePathAndLoad():
	savePath = "user://" + sceneSelector.get_child(0).name + ".save"
	if (loadActive):
		Load()
		loadActive = false

func Save():
	SaveMapData(FileAccess.open(savePath, FileAccess.WRITE))
	SavePlayerData(FileAccess.open(playerDataSavePath, FileAccess.WRITE))

func SaveMapData(file):
	file.store_var(playerRef.global_position)

func SavePlayerData(file):
	file.store_var(playerRef.transformationChangeRef.currentTransformationSet)
	file.store_var(playerRef.transformationChangeRef.currentOriginalObjectPath)
	file.store_var(playerRef.playerSubstitutionAttack.currentSubstitutionStacks)
	file.store_var(playerRef.playerProgressionTrack.unlockKeyTypes)
	file.store_var(playerRef.playerProgressionTrack.unlockKeyIDs)
	file.store_var(playerRef.playerProgressionTrack.usedUnlockKeyForDoors)
	file.store_var(playerRef.playerProgressionTrack.activeQuests)
	file.store_var(playerRef.playerProgressionTrack.activeQuestsStages)
	file.store_var(playerRef.playerProgressionTrack.activeQuestNameForAdvancers)
	file.store_var(playerRef.playerProgressionTrack.activeQuestsAdvancers)

func Load():
	LoadMapData()
	LoadPlayerData()
	LoadOperations()

func LoadMapData():
	if (FileAccess.file_exists(savePath)):
		var file = FileAccess.open(savePath, FileAccess.READ)
		lastPos = file.get_var()
		stopResetPosition = false
	else:
		stopResetPosition = true

func LoadPlayerData():
	playerRef.playerProgressionTrack.ClearAll()
	if (FileAccess.file_exists(playerDataSavePath)):
		var file = FileAccess.open(playerDataSavePath, FileAccess.READ)
		lastTransformationSet = file.get_var()
		lastObjectOriginalPath = file.get_var()
		playerRef.playerSubstitutionAttack.currentSubstitutionStacks = file.get_var()
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.unlockKeyTypes)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.unlockKeyIDs)
		ExtractArray(file.get_var(), playerRef.playerProgressionTrack.usedUnlockKeyForDoors)
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
	if (!stopResetPosition): playerRef.global_position = lastPos
	if (lastTransformationSet):
		var new_trs_scene = load(lastObjectOriginalPath)
		var new_trs: TransformationObjectData = new_trs_scene.instantiate()
		new_trs.GetScale()
		playerRef.transformationChangeRef.SaveNewTransformation(new_trs)
	else:
		playerRef.transformationChangeRef.SetNoTransformation()
