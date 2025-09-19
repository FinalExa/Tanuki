class_name LevelUnlockKeyDoor
extends Node2D

@export var sceneType: GameplayScene.SceneType
@export var requiredKeys: int
@export var advancesQuest: bool
@export var questToAdvance: MapQuest
var registeredKeys: Array[int]
var activated: bool

@export var closedState: Node2D
@export var openState: Node2D

func _ready():
	Activate()
	call_deferred("RemoveOpenState")

func RegisterKey(keyID: int):
	if (!registeredKeys.has(keyID)):
		registeredKeys.push_back(keyID)
		if (registeredKeys.size() == requiredKeys):
			call_deferred("OpenDoor")

func Activate():
	activated = true

func Deactivate():
	activated = false

func OpenDoor():
	closedState.queue_free()
	if (advancesQuest && questToAdvance != null):
		questToAdvance.AdvanceStage(false, false)
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
	if (body is PlayerCharacter && activated):
		ContactWithplayer(body)

func ContactWithplayer(playerRef: PlayerCharacter):
	playerRef.playerProgressionTrack.AssignKeysToDoor(self)
