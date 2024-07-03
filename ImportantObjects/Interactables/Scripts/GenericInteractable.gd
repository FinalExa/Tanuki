class_name GenericInteractable
extends Node2D

@export var neededString: String
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
var sceneMaster: SceneMaster
var activated: bool

func _ready():
	sceneMaster = get_tree().root.get_child(0)
	if (!activated): FirstStartup()

func FirstStartup():
	pass

func AttackInteraction(receivedString):
	if (neededString == receivedString && !activated):
		ExecuteExtraEffect()
		SaveOnDestroy()
		FinalState()

func ExecuteLoadOperation():
	SaveDestroySignalToOtherObject()
	activated = true
	FinalState()

func FinalState():
	get_parent().remove_child(self)

func ExecuteExtraEffect():
	pass

func SaveOnDestroy():
	if (savedOnDestroy):
		sceneMaster.AddPathString(self)

func SaveDestroySignalToOtherObject():
	if (objectToSendDestoySignal != null):
		objectToSendDestoySignal.DestroyedSignal()
