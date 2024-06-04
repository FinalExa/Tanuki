class_name EnemyController
extends CharacterBody2D

@export var patrolIndicators: Array[PatrolIndicator]
@export var guardProperties: Array[String]
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator
@export var guardPatrol: GuardPatrol

func GetRotator():
	return enemyRotator
