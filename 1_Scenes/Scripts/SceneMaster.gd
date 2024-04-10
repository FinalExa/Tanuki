class_name SceneMaster
extends Node2D

var savedDeletePaths: Array[String]
var savePath: String
var playerDataSavePath: String = "user://PlayerData.save"
var stopResetPosition: bool

var lastPos: Vector2
var lastTransformationSet: bool
var lastObjectOriginalPath: String

@export var frameMaster: FrameMaster
var playerRef: PlayerCharacter

func _ready():
	savePath = "user://"+ self.name +".save"
	for i in get_child_count():
		if (get_child(i) is PlayerCharacter):
			playerRef = get_child(i)
			break
	Load()

func AddDeletePath(newPath: String):
	if(!savedDeletePaths.has(newPath)):
		savedDeletePaths.push_back(newPath)

func Save():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(savedDeletePaths)
	file.store_var(playerRef.global_position)
	file = FileAccess.open(playerDataSavePath, FileAccess.WRITE)
	file.store_var(playerRef.transformationChangeRef.currentTransformationSet)
	file.store_var(playerRef.transformationChangeRef.currentOriginalObjectPath)

func Load():
	if (FileAccess.file_exists(savePath)):
		var file = FileAccess.open(savePath, FileAccess.READ)
		var result = file.get_var()
		if (result != null):
			savedDeletePaths.clear()
			for i in result.size():
				savedDeletePaths.push_back(result[i])
		lastPos = file.get_var()
		stopResetPosition = false
	else:
		stopResetPosition = true
	if (FileAccess.file_exists(playerDataSavePath)):
		var file = FileAccess.open(playerDataSavePath, FileAccess.READ)
		lastTransformationSet = file.get_var()
		lastObjectOriginalPath = file.get_var()
	LoadOperations()

func LoadOperations():
	if (!stopResetPosition): playerRef.global_position = lastPos
	if (lastTransformationSet):
		var new_trs_scene = load(lastObjectOriginalPath)
		var new_trs = new_trs_scene.instantiate()
		playerRef.transformationChangeRef.set_temp_trs(new_trs.transformedName, new_trs.transformedMaxSpeed, new_trs.transformedProperties, new_trs.transformedCollider, new_trs.transformedTexture.texture, new_trs.transformedTexture.scale, new_trs.transformedAttackPath, new_trs.originalObjectPath)
		playerRef.transformationChangeRef.actually_set_new_transformation()
		playerRef.transformationChangeRef.unset_temp_trs()
	if savedDeletePaths.size() > 0:
		for i in savedDeletePaths.size():
			TranslateStringIntoPathResult(self, savedDeletePaths[i])
	

func TranslateStringIntoPathResult(currentNode: Node2D,string: String):
	var newString: String = ""
	while (string[0] != "/"):
		newString += string[0]
		string = string.right(string.length()-1)
	string = string.right(string.length()-1)
	if (newString == currentNode.name):
		TranslateStringIntoPathResult(currentNode, string)
	else:
		for i in currentNode.get_child_count():
			if (currentNode.get_child(i).name == newString):
				currentNode = currentNode.get_child(i)
				break
		if (string.is_empty()):
			currentNode.ExecuteLoadOperation()
		else:
			TranslateStringIntoPathResult(currentNode, string)

func SetCurrentNodeInPath(node: Node2D):
	var path: Array[String] = []
	path.push_front(node.name)
	var reached: bool = false
	while (!reached):
		node = node.get_parent()
		path.push_front(node.name)
		if (node is SceneMaster):
			reached = true
	return path

func ComposePathString(path: Array[String]):
	var pathString: String = ""
	for i in path.size():
		pathString += path[i] + "/"
	return pathString

func AddPathString(baseNode: Node2D):
	AddDeletePath(ComposePathString(SetCurrentNodeInPath(baseNode)))
