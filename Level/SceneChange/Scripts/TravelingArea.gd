class_name TravelingArea
extends Area2D

@export var sendToTravelID: int
@export var sceneToLoad: String
@export var usePositional: bool
@export var removeTransformation: bool
@export var deleteRoomData: bool
var sceneMasterRef: SceneMaster

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		Travel(body)

func Travel(playerRef: PlayerCharacter):
	playerRef.velocity = Vector2.ZERO
	playerRef.transformationChangeRef.transformationActivation.CheckForDeactivateTransformation()
	if (removeTransformation): playerRef.transformationChangeRef.SetNoTransformation()
	playerRef.SetTraveling(sendToTravelID, usePositional)
	if (deleteRoomData): sceneMasterRef.Load()
	sceneMasterRef.sceneSelector.call_deferred("ChangeScene", sceneToLoad)
