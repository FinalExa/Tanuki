class_name GenericInteractable
extends Node2D

@export var neededString: String
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
var sceneMaster: SceneMaster

func _ready():
	sceneMaster = get_tree().root.get_child(0)

func AttackInteraction(receivedString):
	if (neededString == receivedString):
		ExecuteExtraEffect()
		SaveOnDestroy()
		get_parent().remove_child(self)

func ExecuteLoadOperation():
	SaveDestroySignalToOtherObject()
	get_parent().remove_child(self)

func ExecuteExtraEffect():
	pass

func SaveOnDestroy():
	if (savedOnDestroy):
		sceneMaster.AddPathString(self)

func SaveDestroySignalToOtherObject():
	if (objectToSendDestoySignal != null):
		objectToSendDestoySignal.DestroyedSignal()
