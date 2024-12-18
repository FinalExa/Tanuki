class_name HyottokoController
extends EnemyController

var isSpottingPlayer: bool
var isReachingPoint: bool
var isInRage: bool

@export var hyottokoRange: HyottokoRange
@export var hyottokoPushDistanceFromPlayer: float
@export var hyottokoReachPoint: HyottokoReachPoint
@export var hyottokoAttack: ExecuteAttack
var playerRef: PlayerCharacter

func InterruptAttacks():
	if (hyottokoAttack.attackLaunched):
		hyottokoAttack.ForceEndAttack()

func SetDamaged(direction: Vector2, tier: EnemyStunned.StunTier):
	hitByPlayerSound.play()
	stunnedHit.play()
	InterruptAttacks()
	emit_signal("damaged", direction)
	enemyStunned.start_stun(direction, tier)
