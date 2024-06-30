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
