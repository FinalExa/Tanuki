class_name TravelingArea
extends Area2D

@export var sendToTravelID: int
@export var sceneToLoad: String
var sceneMasterRef: SceneMaster

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		Travel(body)

func Travel(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.CheckForDeactivateTransformation()
	playerRef.SetTraveling(sendToTravelID)
	sceneMasterRef.sceneSelector.call_deferred("ChangeScene", sceneToLoad)
