class_name HyottokoReachPoint
extends Node

@export var hyottokoController: HyottokoController
@export var enemyMovement: EnemyMovement
@export var distanceFromPointToReach: float
@export var durationAfterReachingPoint: float
var pointReachedTimer: float
var pointToReach: Vector2

func SetPointToReach(point: Vector2):
	hyottokoController.isReachingPoint = true
	pointToReach = point
	pointReachedTimer = durationAfterReachingPoint
	enemyMovement.set_location_target(pointToReach)
	hyottokoController.enemyStatus.updateText("REACHING POINT")

func StopReachingPoint():
	hyottokoController.isReachingPoint = false
	hyottokoController.enemyStatus.updateText("")
