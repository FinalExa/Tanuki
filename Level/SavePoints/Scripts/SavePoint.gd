class_name SavePoint
extends Area2D

var sceneMasterRef: SceneMaster
var playerRef: PlayerCharacter
@export var onEnter: bool
@export var oneTimeSave: bool

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)

func Save():
	print("saved")
	if (!oneTimeSave):
		sceneMasterRef.Save()
	else:
		sceneMasterRef.SaveAndDeleteOneTimeSave(self.get_path())
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
