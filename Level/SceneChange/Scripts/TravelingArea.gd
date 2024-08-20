class_name TravelingArea
extends Area2D

@export var sendToTravelID: int
@export var sceneToLoad: String
@export var spawnLocation: Node2D
var sceneMasterRef: SceneMaster

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		Travel(body)

func Travel(playerRef: PlayerCharacter):
	playerRef.SetTraveling(sendToTravelID)
	sceneMasterRef.sceneSelector.call_deferred("ChangeScene", sceneToLoad)
