class_name LevelUnlockKeyDoor
extends Node2D

@export var sceneType: GameplayScene.SceneType
@export var requiredKeys: int
@export var registeredKeys: Array[int]

@export var closedState: Node2D
@export var openState: Node2D

func _ready():
	openState.get_parent().remove_child(openState)

func RegisterKey(keyID: int):
	if (!registeredKeys.has(keyID)):
		registeredKeys.push_back(keyID)
		if (registeredKeys.size() == requiredKeys):
			call_deferred("OpenDoor")

func OpenDoor():
	closedState.get_parent().remove_child(closedState)
	openState.reparent(self)
