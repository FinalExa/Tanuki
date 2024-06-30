class_name HyottokoReachPoint
extends Node

@export var hyottokoController: HyottokoController
@export var enemyMovement: EnemyMovement
@export var distanceFromPointToReach: float
@export var durationAfterReachingPoint: float
var pointToReach: Vector2

func SetPointToReach(point: Vector2):
	hyottokoController.isReachingPoint = true
	pointToReach = point
	enemyMovement.set_location_target(pointToReach)
