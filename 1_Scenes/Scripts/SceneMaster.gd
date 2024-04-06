class_name SceneMaster
extends Node2D

var savedDeletePaths: Array[String]
var savePath: String

func _ready():
	savePath = "user://"+ self.name +".save"
	Load()

func _process(_delta):
	ManualSave()
	#ManualLoad()

func AddDeletePath(newPath: String):
	if(!savedDeletePaths.has(newPath)):
		savedDeletePaths.push_back(newPath)

func ManualSave():
	if (Input.is_action_just_pressed("save")):
		Save()

func ManualLoad():
	if (Input.is_action_just_pressed("load")):
		Load()

func Save():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(savedDeletePaths)

func Load():
	if (FileAccess.file_exists(savePath)):
		var file = FileAccess.open(savePath, FileAccess.READ)
		savedDeletePaths.clear()
		var result = file.get_var()
		for i in result.size():
			savedDeletePaths.push_back(result[i])
		LoadOperations()

func LoadOperations():
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
