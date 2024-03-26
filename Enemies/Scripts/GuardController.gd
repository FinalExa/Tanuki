class_name GuardController
extends CharacterBody2D

signal damaged

var isInPatrol: bool = true
var isInAlert: bool
var isChecking: bool
var isInResearch: bool
var isStunned: bool
var characterRef

@export var patrolIndicators: Array[PatrolIndicator]
@export var guardProperties: Array[String]
@export var navigationRegion: NavigationRegion2D

@export var guardCheck: GuardCheck
@export var guardResearch: GuardResearch
@export var guardStunned: GuardStunned
@export var guardMovement: GuardMovement
@export var guardPatrol: GuardPatrol
@export var guardAlert: GuardAlert
@export var guardRotator: GuardRotator
@export var guardAlertValue: GuardAlertValue
var guardsLookingForMe: Array[GuardResearch]

func _on_player_character_give_self_reference(reference):
	characterRef = reference

func is_damaged(direction: Vector2):
	if (isInAlert):
		guardStunned.stunnedFromAlert = true
	emit_signal("damaged", direction)

func arrays_have_same_content(array1: Array[Node2D], array2: Array[Node2D]):
	if (array1.size() != array2.size()):
		return false
	for i in array1.size():
		if (array1[i] != array2[i]):
			return false
	return true
