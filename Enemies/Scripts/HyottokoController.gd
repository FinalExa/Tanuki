class_name HyottokoController
extends EnemyController

var isSpottingPlayer: bool
var isReachingPoint: bool
var isInRage: bool

@export var hyottokoRange: HyottokoRange
@export var hyottokoPushDistanceFromPlayer: float
@export var hyottokoReachPoint: HyottokoReachPoint
var playerRef: PlayerCharacter

func SetInRage():
	isInRage = true

func SetOutOfRage():
	isInRage = false

func SetDamaged(direction: Vector2):
	hitByPlayerSound.play()
	stunnedHit.play()
	emit_signal("damaged", direction)
	enemyStunned.start_stun(direction)
