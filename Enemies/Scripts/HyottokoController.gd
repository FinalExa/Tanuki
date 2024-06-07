class_name HyottokoController
extends EnemyController

var isSpottingPlayer: bool
var isInRage: bool

@export var hyottokoRange: HyottokoRange
@export var hyottokoPushDistanceFromPlayer: float
var playerRef: PlayerCharacter

func SetInRage():
	isInRage = true

func SetOutOfRage():
	isInRage = false
