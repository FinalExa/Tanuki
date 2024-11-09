class_name HyottokoController
extends EnemyController

var isSpottingPlayer: bool
var isReachingPoint: bool
var isInRage: bool

@export var hyottokoRange: HyottokoRange
@export var hyottokoPushDistanceFromPlayer: float
@export var hyottokoReachPoint: HyottokoReachPoint
@export var hyottokoNormalAttack: ExecuteAttack
@export var hyottokoRageAttack: ExecuteAttack
var playerRef: PlayerCharacter

func InterruptAttacks():
	if (hyottokoNormalAttack.attackLaunched):
		hyottokoNormalAttack.ForceEndAttack()
	if (hyottokoRageAttack.attackLaunched):
		hyottokoRageAttack.ForceEndAttack()

func SetInRage():
	isInRage = true

func SetOutOfRage():
	isInRage = false

func SetDamaged(direction: Vector2):
	hitByPlayerSound.play()
	stunnedHit.play()
	InterruptAttacks()
	emit_signal("damaged", direction)
	enemyStunned.start_stun(direction)
