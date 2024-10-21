class_name LevelUnlockKeyDoor
extends Node2D

@export var sceneType: GameplayScene.SceneType
@export var requiredKeys: int
var registeredKeys: Array[int]

@export var closedState: Node2D
@export var openState: Node2D

func _ready():
	if (openState != null):
		openState.get_parent().remove_child(openState)

func RegisterKey(keyID: int):
	if (!registeredKeys.has(keyID)):
		registeredKeys.push_back(keyID)
		if (registeredKeys.size() == requiredKeys):
			call_deferred("OpenDoor")

func OpenDoor():
	closedState.queue_free()
	if (openState != null):
		openState.reparent(self)

func _on_area_2d_body_entered(body):
	if (body is PlayerCharacter):
		ContactWithplayer(body)

func ContactWithplayer(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.AssignKeysToDoor(self)
