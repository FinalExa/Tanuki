class_name GuardController
extends CharacterBody2D

signal get_character_ref
signal damaged

var isInPatrol: bool = true
var isInAlert: bool
var isChecking: bool
var isInResearch: bool
var isStunned: bool
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

@export var guardCheck: GuardCheck
@export var guardResearch: GuardResearch
@export var guardStunned: GuardStunned
var guardsLookingForMe: Array[GuardResearch]

func _ready():
	emit_signal("get_character_ref")

func _on_player_character_give_self_reference(reference):
	characterRef = reference

func is_damaged():
	emit_signal("damaged")
