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
	sceneMaster = get_tree().root.get_child(0)
	if (!activated): FirstStartup()

func _process(delta):
	if (cooldownActive):
		if (cooldownTimer > 0):
			cooldownTimer -= delta
			return
		SendInteractSignal()
		RestoreToParent()
		cooldownActive = false

func FirstStartup():
	pass

func AttackInteraction(receivedString):
	if (neededString == receivedString && !activated):
		ExecuteExtraEffect()
		SendInteractSignal()
		SaveOnDestroy()
		FinalState()

func ExecuteLoadOperation():
	SaveDestroySignalToOtherObject()
	activated = true
	FinalState()

func RestoreToParent():
	if (get_parent() == null):
		reparent(parentRef)

func FinalState():
	parentRef = get_parent()
	parentRef.remove_child(self)
	if (!hasCooldown):
		queue_free()
		return
	cooldownTimer = cooldownDuration
	cooldownActive = true

func ExecuteExtraEffect():
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
