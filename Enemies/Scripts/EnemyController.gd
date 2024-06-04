class_name EnemyController
extends CharacterBody2D

var isInPatrol: bool = true

@export var patrolIndicators: Array[PatrolIndicator]
@export var guardProperties: Array[String]
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator
@export var enemyPatrol: EnemyPatrol

func GetRotator():
	return enemyRotator
