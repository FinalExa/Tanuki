class_name GenericInteractable
extends Node2D

@export var neededProperties: Array[String]
@export var hasCooldown: bool
@export var cooldownDuration: float
@export var questToSendProgressSignal: MapQuest
@export var sendSignalToQuestOnDestroyed: bool
@export var destroyOnEnd: bool
@export var receiveRefAttack: bool
var parentRef: Node2D
var cooldownActive: bool
var cooldownTimer: float

func _ready():
	parentRef = get_parent()
	ReadyOperations()

func ReadyOperations():
	pass

func _process(delta):
	if (cooldownActive):
		if (cooldownTimer > 0):
			cooldownTimer -= delta
			return
		cooldownActive = false

func FirstStartup():
	pass

func InteractionWithRef(receivedString: String, receivedRef):
	if (neededProperties.has(receivedString) && !cooldownActive):
		ExecuteRefEffect(receivedRef)

func AttackInteraction(receivedString: String):
	if (neededProperties.has(receivedString) && !cooldownActive):
		ExecuteExtraEffect()
		FinalState()

func FinalState():
	if (!hasCooldown):
		if (sendSignalToQuestOnDestroyed): QuestSignal()
		if (destroyOnEnd): queue_free()
		return
	cooldownTimer = cooldownDuration
	cooldownActive = true

func ExecuteExtraEffect():
	pass

func ExecuteRefEffect(_receivedRef):
	pass

func QuestSignal():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
