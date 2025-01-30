class_name GuardController
extends EnemyController

var isInAlert: bool
var isChecking: bool
var isInResearch: bool

@export var guardCheck: GuardCheck
@export var guardResearch: GuardResearch
@export var guardAlert: GuardAlert
@export var guardDistraction: GuardDistraction
@export var enemyAttack: EnemyAttack

func is_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (isInAlert):
		enemyStunned.stunnedFromAlert = true
	Damaged(direction, tier)

func RepelExtraOperation():
	if (!isStunned && !isInAlert):
		guardResearch.InitializeResearchWithLocation(repelledPosition)
