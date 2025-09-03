class_name WardenBossController
extends WardenController

@export var newPatrol: PatrolIndicator
var changedPatrol: bool

func AdvanceBossPhase():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
	if (!changedPatrol):
		patrolIndicators.clear()
		patrolIndicators.push_back(newPatrol)
		enemyPatrol.loadedPatrolIndicator = patrolIndicators[0]
		enemyStunned.end_stun()
		enemyPatrol.reset_patrol()
		enemyPatrol.restart_patrol()
		wardenCheck.Deactivate()
		changedPatrol = true

func _on_enemy_movement_reached_destination():
	if (!wardenCheck.activated):
		wardenCheck.Activate()
