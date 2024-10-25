class_name GenericInteractable
extends Node2D

@export var neededProperties: Array[String]
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
@export var objectoToSendInteractSignal: PuzzleObject
@export var hasCooldown: bool
@export var cooldownDuration: float
@export var questToSendProgressSignal: MapQuest
@export var sendSignalToQuestOnDestroyed: bool
var parentRef: Node2D
var cooldownActive: bool
var cooldownTimer: float
var sceneMaster: SceneMaster
var activated: bool

func _ready():
	parentRef = get_parent()
	sceneMaster = get_tree().root.get_child(0)
	if (!activated): FirstStartup()

func _process(delta):
	if (cooldownActive):
		if (cooldownTimer > 0):
			cooldownTimer -= delta
			return
		SendInteractSignal()
		cooldownActive = false

func FirstStartup():
	pass

func InteractionWithRef(receivedString: String, receivedRef):
	if (neededProperties.has(receivedString) && !activated && !cooldownActive):
		ExecuteRefEffect(receivedRef)

func AttackInteraction(receivedString: String):
	if (neededProperties.has(receivedString) && !activated && !cooldownActive):
		ExecuteExtraEffect()
		SendInteractSignal()
		SaveOnDestroy()
		FinalState()

func ExecuteLoadOperation():
	SaveDestroySignalToOtherObject()
	activated = true
	FinalState()

func FinalState():
	if (!hasCooldown):
		call_deferred("RemoveChild")
		if (sendSignalToQuestOnDestroyed): QuestSignal()
		queue_free()
		return
	cooldownTimer = cooldownDuration
	cooldownActive = true

func RemoveChild():
	parentRef.remove_child(self)

func ExecuteExtraEffect():
	pass

func ExecuteRefEffect(_receivedRef):
	pass

func SaveOnDestroy():
	if (savedOnDestroy):
		sceneMaster.AddPathString(self)

func SaveDestroySignalToOtherObject():
	if (objectToSendDestoySignal != null):
		objectToSendDestoySignal.DestroyedSignal()

func SendInteractSignal():
	if (objectoToSendInteractSignal != null):
		objectoToSendInteractSignal.InteractSignal()

func QuestSignal():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStage()
