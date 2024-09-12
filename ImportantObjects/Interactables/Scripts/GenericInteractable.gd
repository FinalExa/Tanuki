class_name GenericInteractable
extends Node2D

@export var neededString: String
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
@export var objectoToSendInteractSignal: PuzzleObject
@export var hasCooldown: bool
@export var cooldownDuration: float
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
	if (neededString == receivedString && !activated && !cooldownActive):
		ExecuteRefEffect(receivedRef)

func AttackInteraction(receivedString: String):
	if (neededString == receivedString && !activated && !cooldownActive):
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
