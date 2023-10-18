class_name GuardController
extends CharacterBody2D

signal get_character_ref

var characterRef

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

func _ready():
	emit_signal("get_character_ref")


func _on_player_character_give_self_reference(reference):
	characterRef = reference
