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

@export var patrolActions: Array[ActionTypes]
@export var waitActions: Array[float]
@export var moveActions: Array[Node2D]
@export var lookActions: Array[LookDirections]
