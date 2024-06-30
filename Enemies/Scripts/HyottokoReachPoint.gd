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

func _on_hyottoko_damaged(_direction: Vector2):
	StopReachingPoint()

func StopReachingPoint():
	hyottokoController.isReachingPoint = false
