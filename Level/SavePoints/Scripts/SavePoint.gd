class_name SavePoint
extends Area2D

var sceneMasterRef: SceneMaster
var playerRef: PlayerCharacter
var selfPath: String
@export var removeTransformationBeforeSave: bool
@export var onEnter: bool
@export var oneTimeSave: bool

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)
	selfPath = self.get_path()
	if (sceneMasterRef.oneTimeSavePoints.size() == 0):
		sceneMasterRef.LoadMapData()
	if (sceneMasterRef.oneTimeSavePoints.has(selfPath)):
		queue_free()

func Save():
	if (removeTransformationBeforeSave):
		sceneMasterRef.playerRef.transformationChangeRef.SetNoTransformation()
	if (!oneTimeSave):
		sceneMasterRef.Save()
	else:
		if (!sceneMasterRef.oneTimeSavePoints.has(selfPath)):
			sceneMasterRef.SaveAndDeleteOneTimeSave(selfPath)
		self.queue_free()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		SavePointOperations(body)

func SavePointOperations(player: PlayerCharacter):
	if (!onEnter):
		player.SetSavePoint(self)
		player = playerRef
	else:
		Save()

func _on_body_exited(body):
	if (body is PlayerCharacter):
		UnsetPlayer()

func UnsetPlayer():
	if (playerRef != null):
		playerRef.RemoveSavePoint()
		playerRef = null
