class_name WardenAlertArea
extends Area2D

var guardsInArea: Array[GuardController]
@export var wardenCheck: WardenCheck

func _process(delta):
	UpdatePlayerPositionToGuardsInArea()

func UpdatePlayerPositionToGuardsInArea():
	if (wardenCheck.playerIn && guardsInArea.size() > 0):
		for i in guardsInArea.size():
			UpdateGuardWithInfo(guardsInArea[i])

func UpdateGuardWithInfo(guard: GuardController):
	if (guard.isInAlert && guard.guardAlert.targetNotSeenActive):
		guard.guardAlert.goToAlertStartLocation = true
		guard.guardAlert.SetAlertTargetLastInfo(wardenCheck.playerRef)

func SetGuardAlerted(guard: GuardController):
	if (!guard.isInAlert && !guard.isStunned):
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		if (guard.isChecking):
			guard.guardCheck.stop_guardCheck()
		if (guard.isInResearch):
			guard.guardResearch.StopResearch()
		guard.guardAlert.start_alert(wardenCheck.playerRef)
	if (!guardsInArea.has(guard)):
		guardsInArea.push_back(guard)

func ClearGuardsInArea():
	guardsInArea.clear()

func _on_body_entered(body):
	if (body is GuardController):
		SetGuardAlerted(body)

func _on_body_exited(body):
	if (guardsInArea.has(body)):
		guardsInArea.erase(body)
