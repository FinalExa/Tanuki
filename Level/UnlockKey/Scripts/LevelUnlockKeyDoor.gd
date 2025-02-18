class_name LevelUnlockKeyDoor
extends Node2D

@export var sceneType: GameplayScene.SceneType
@export var requiredKeys: int
var registeredKeys: Array[int]

@export var closedState: Node2D
@export var openState: Node2D

func _ready():
	call_deferred("RemoveOpenState")

func RegisterKey(keyID: int):
	if (!registeredKeys.has(keyID)):
		registeredKeys.push_back(keyID)
		if (registeredKeys.size() == requiredKeys):
			call_deferred("OpenDoor")

func OpenDoor():
	closedState.queue_free()
	AddOpenState()

func RemoveOpenState():
	if (openState != null):
		openState.hide()
		FindOpenStateColliders(true)

func FindOpenStateColliders(operationType: bool):
	for i in openState.get_child_count():
		if (openState.get_child(i) is CollisionShape2D):
			OperateOpenStateCollider(openState.get_child(i), operationType)

func OperateOpenStateCollider(collider: CollisionShape2D, operationType: bool):
	collider.disabled = operationType

func AddOpenState():
	if (openState != null):
		openState.show()
		FindOpenStateColliders(false)

func _on_area_2d_body_entered(body):
	if (body is PlayerCharacter):
		ContactWithplayer(body)

func ContactWithplayer(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.AssignKeysToDoor(self)
