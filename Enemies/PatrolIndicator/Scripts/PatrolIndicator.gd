class_name PatrolIndicator
extends Node2D

enum ActionTypes {
	WAIT,
	MOVE,
	LOOK_AROUND
}

enum LookDirections {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var patrolIndexes: Array[PatrolIndex]
