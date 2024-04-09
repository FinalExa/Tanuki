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

@export var guardCheck: GuardCheck
@export var guardResearch: GuardResearch
@export var guardStunned: GuardStunned
@export var guardMovement: GuardMovement
@export var guardPatrol: GuardPatrol
@export var guardAlert: GuardAlert
@export var guardRotator: GuardRotator
@export var guardAlertValue: GuardAlertValue
@export var enemyAttack: EnemyAttack
@export var spriteRef: AnimatedSprite2D
var guardsLookingForMe: Array[GuardResearch]

func _ready():
	spriteRef.play("idle")

func _process(delta):
	GuardAnimations()

func GuardAnimations():
	if (velocity.x < 0):
		spriteRef.flip_h = true
	else:
		if (velocity.x > 0):
			spriteRef.flip_h = false

func _on_player_character_give_self_reference(reference):
	characterRef = reference

func is_damaged(direction: Vector2):
	if (isInAlert):
		guardStunned.stunnedFromAlert = true
	emit_signal("damaged", direction)
