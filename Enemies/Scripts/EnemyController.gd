class_name EnemyController
extends CharacterBody2D

signal damaged
signal damaged_no_direction
signal stop_attack

var isInPatrol: bool = true
var isStunned: bool
var characterRef

@export var patrolIndicators: Array[PatrolIndicator]
@export var startingIndex: int
@export var guardProperties: Array[String]
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator
@export var enemyPatrol: EnemyPatrol
@export var enemyStatus: EnemyStatus
@export var enemyStunned: EnemyStunned
@export var spriteRef: AnimatedSprite2D
@export var enemyMovementSounds: MovementSounds
@export var hitByPlayerSound: AudioStreamPlayer2D
@export var stunnedHit: AudioStreamPlayer2D

var guardsLookingForMe: Array[GuardResearch]

func _ready():
	spriteRef.play("idle")

func _process(_delta):
	GuardAnimations()

func _physics_process(delta):
	move_and_slide()

func GuardAnimations():
	if (velocity.x < 0):
		spriteRef.flip_h = true
	else:
		if (velocity.x > 0):
			spriteRef.flip_h = false

func is_damaged(direction: Vector2):
	SetDamaged(direction)

func SetDamaged(direction: Vector2):
	hitByPlayerSound.play()
	stunnedHit.play()
	emit_signal("damaged", direction)
	emit_signal("damaged_no_direction")
	emit_signal("stop_attack")

func GetRotator():
	return enemyRotator
