class_name EnemyController
extends CharacterBody2D

signal damaged
signal damaged_no_direction
signal repelled
signal stop_attack

var isInPatrol: bool = true
var isStunned: bool
var isRepelled: bool
var repelledTimer: float
var repelledSpeed: float
var repelledDirection: Vector2
var repelledPosition: Vector2
var characterRef

@export var enemyName: String
@export var patrolIndicators: Array[PatrolIndicator]
@export var repelledTime: float
@export var repelledDistance: float
@export var repelledOffset: float
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

var guardsLookingForMe: Array[GuardResearch]

func _ready():
	spriteRef.play("idle")
	repelledSpeed = 0
	if (repelledTime > 0):
		repelledSpeed = repelledDistance / repelledTime

func _process(_delta):
	GuardAnimations()

func _physics_process(delta):
	Repelled(delta)
	move_and_slide()

func GuardAnimations():
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
	if (sendSignalToQuestOnStunned): QuestSignal()
	emit_signal("damaged", direction, tier)
	emit_signal("damaged_no_direction")
	emit_signal("stop_attack")

func IsRepelled(direction: Vector2):
	if (repelledSpeed > 0):
		isRepelled = true
		emit_signal("stop_attack")
		velocity = Vector2.ZERO
		repelledTimer = repelledTime
		repelledDirection = direction
		repelledPosition = self.global_position
		enemyRepelled.look_at(enemyRepelled.global_position + repelledDirection)
		enemyRepelled.rotation_degrees += repelledOffset

func Repelled(delta):
	if (isRepelled):
		if (repelledTimer > 0):
			repelledTimer -= delta
			velocity = repelledSpeed * repelledDirection
			return
		EndRepel()

func EndRepel():
	velocity = Vector2.ZERO
	RepelExtraOperation()
	isRepelled = false

func RepelExtraOperation():
	pass

func GetRotator():
	return enemyRotator

func QuestSignal():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
