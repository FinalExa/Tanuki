class_name WardenBossController
extends WardenController

@export var newPatrol: PatrolIndicator
@export var newAlertArea: WardenAlertArea
var changedPatrol: bool = false

func AdvanceBossPhase():
	if (!changedPatrol):
		patrolIndicators.clear()
		patrolIndicators.push_back(newPatrol)
		wardenAlertArea.queue_free()
		wardenAlertArea = newAlertArea
		wardenCheck.wardenAlertArea = newAlertArea
		wardenAlertArea.wardenCheck = wardenCheck
		enemyPatrol.loadedPatrolIndicator = patrolIndicators[0]
		enemyPatrol.reset_patrol()
		enemyPatrol.restart_patrol()
		wardenCheck.Deactivate()
		changedPatrol = true
		return
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)

func _on_enemy_movement_reached_destination():
	if (!wardenCheck.activated):
		wardenCheck.Activate()
