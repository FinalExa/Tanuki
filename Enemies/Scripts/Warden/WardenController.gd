class_name WardenController
extends EnemyController

@export var wardenCheck: WardenCheck
@export var wardenAlertArea: WardenAlertArea
@export var wardenCollider: CollisionShape2D

func ReadyOperations():
	wardenCheck.wardenAlertArea = wardenAlertArea
	wardenAlertArea.wardenCheck = wardenCheck
	wardenCheck.RemoveArea()

func AdvanceBossPhase():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
	if (patrolIndicators.size() > 1):
		patrolIndicators.remove_at(0)
		enemyPatrol.loadedPatrolIndicator = patrolIndicators[0]
		enemyStunned.end_stun()
		enemyPatrol.reset_patrol()
		enemyPatrol.restart_patrol()
