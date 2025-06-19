class_name GenericInteractable
extends Node2D

@export var neededProperties: Array[String]
@export var hasCooldown: bool
@export var cooldownDuration: float
@export var questToSendProgressSignal: MapQuest
@export var sendSignalToQuestOnDestroyed: bool
@export var destroyOnEnd: bool
@export var receiveRefAttack: bool
@export var animatedSpriteRef: AnimatedSprite2D
@export var animationToPlay: String
var parentRef: Node2D
var cooldownActive: bool
var cooldownTimer: float

func _ready():
	parentRef = get_parent()
	if (animatedSpriteRef != null):
		animatedSpriteRef.play(animationToPlay)
	ReadyOperations()

func ReadyOperations():
	pass

func _process(delta):
	Cooldown(delta)

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
		FinalStateExtraExecution()
		return
	cooldownTimer = cooldownDuration
	cooldownActive = true
	CooldownActivatedEffect()
	FinalStateExtraExecution()

func ExecuteExtraEffect():
	pass

func FinalStateExtraExecution():
	pass

func ExecuteRefEffect(_receivedRef):
	pass

func Cooldown(delta):
	if (cooldownActive):
		if (cooldownTimer > 0):
			cooldownTimer -= delta
			return
		cooldownActive = false
		CooldownFinishedEffect()

func CooldownActivatedEffect():
	pass

func CooldownFinishedEffect():
	pass

func QuestSignal():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
