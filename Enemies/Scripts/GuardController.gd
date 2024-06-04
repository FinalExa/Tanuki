class_name GuardController
extends EnemyController

var isInAlert: bool
var isChecking: bool
var isInResearch: bool

@export var guardCheck: GuardCheck
@export var guardResearch: GuardResearch
@export var guardAlert: GuardAlert
@export var guardAlertValue: GuardAlertValue
@export var enemyAttack: EnemyAttack

func is_damaged(direction: Vector2):
	if (isInAlert):
		enemyStunned.stunnedFromAlert = true
	emit_signal("damaged", direction)
