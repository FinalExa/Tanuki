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
@export var animationToPlayOnInteraction: String
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
	ProcessOperations()

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
		PlayAnimationOnInteract()
		if (sendSignalToQuestOnDestroyed): QuestSignal()
		if (destroyOnEnd): queue_free()
		FinalStateExtraExecution()
		return
	PlayAnimationOnInteract()
	cooldownTimer = cooldownDuration
	cooldownActive = true
	CooldownActivatedEffect()
	FinalStateExtraExecution()

func PlayAnimationOnInteract():
	if (animatedSpriteRef != null && animationToPlayOnInteraction != ""):
		animatedSpriteRef.play(animationToPlayOnInteraction)

func ExecuteExtraEffect():
	pass

func FinalStateExtraExecution():
	pass

func ProcessOperations():
	pass

func ExecuteRefEffect(_receivedRef):
	pass

func Cooldown(delta):
	if (cooldownActive):
		if (cooldownTimer > 0):
			cooldownTimer -= delta
			CooldownActiveEffect(delta)
			return
		cooldownActive = false
		CooldownFinishedEffect()

func CooldownActivatedEffect():
	pass

func CooldownActiveEffect(_delta):
	pass

func CooldownFinishedEffect():
	pass

func QuestSignal():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
