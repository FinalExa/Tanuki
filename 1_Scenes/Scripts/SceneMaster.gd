class_name SceneMaster
extends Node2D

var savedDeletePaths: Array[String]
const savePath = "user://variable.save"

func _ready():
	savedDeletePaths.push_front(self.name)

func _process(_delta):
	ManualSave()
	ManualLoad()

func AddDeletePath(newPath: String):
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
