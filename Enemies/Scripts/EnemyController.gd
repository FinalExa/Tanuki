class_name EnemyController
extends CharacterBody2D

signal damaged
signal damaged_no_direction
signal repelled
signal stop_attack

var isInPatrol: bool = true
var isStunned: bool
var isRepelled: bool
var characterRef

@export var enemyName: String
@export var patrolIndicators: Array[PatrolIndicator]

@export var startingIndex: int
@export var enemyProperties: Array[String]
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator
@export var enemyPatrol: EnemyPatrol
@export var enemyStatus: EnemyStatus
@export var enemyStunned: EnemyStunned
@export var enemyRepelled: EnemyRepelled
@export var spriteRef: AnimatedSprite2D
@export var enemyMovementSounds: MovementSounds
@export var hitByPlayerSound: AudioStreamPlayer2D
@export var stunnedHit: AudioStreamPlayer2D
@export var questToSendProgressSignal: MapQuest
@export var sendSignalToQuestOnStunned: bool
@export var sendSignalToQuestOnlyOnce: bool
@export var debug: bool
var questSignalSent: bool

func _ready():
	spriteRef.play("idle")
	ReadyOperations()

func _process(_delta):
	EnemyAnimations()

func _physics_process(_delta):
	move_and_slide()

func ReadyOperations():
	pass

func EnemyAnimations():
	if (velocity.x < 0):
		spriteRef.flip_h = true
	else:
		if (velocity.x > 0):
			spriteRef.flip_h = false

func is_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	Damaged(direction, tier)

func Damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	hitByPlayerSound.play()
	stunnedHit.play()
	if (sendSignalToQuestOnStunned && ((sendSignalToQuestOnlyOnce && !questSignalSent) || !sendSignalToQuestOnlyOnce)): QuestSignal()
	emit_signal("damaged", direction, tier)
	emit_signal("damaged_no_direction")
	emit_signal("stop_attack")
	DamagedExtraOperation(direction, tier)

func DamagedExtraOperation(_direction: Vector2, _tier: EnemyStunned.StunTier):
	pass

func IsRepelled(direction: Vector2):
	if (enemyRepelled.repelledSpeed > 0):
		enemyRepelled.StartRepelled(direction)

func EndRepel():
	RepelEndExtraOperation()
	velocity = Vector2.ZERO
	isRepelled = false

func RepelEndExtraOperation():
	pass

func GetRotator():
	return enemyRotator

func QuestSignal():
	if (questToSendProgressSignal != null):
		if (sendSignalToQuestOnlyOnce): questSignalSent = true
		questToSendProgressSignal.AdvanceStageByObject(self)

func AdvanceBossPhase():
	pass
