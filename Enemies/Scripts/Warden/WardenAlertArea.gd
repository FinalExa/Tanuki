class_name WardenAlertArea
extends Area2D

var guardsInArea: Array[GuardController]
var activated: bool
@export var wardenCheck: WardenCheck

func _process(_delta):
	UpdatePlayerPositionToGuardsInArea()

func SetActive():
	self.show()
	activated = true

func SetInactive():
	self.hide()
	activated = false

func UpdatePlayerPositionToGuardsInArea():
	if (activated && wardenCheck.playerIn && guardsInArea.size() > 0):
		for i in guardsInArea.size():
			SetGuardInAlert(guardsInArea[i])
			UpdateGuardWithInfo(guardsInArea[i])

func UpdateGuardWithInfo(guard: GuardController):
	if (guard.isInAlert && guard.guardAlert.targetNotSeenActive):
		guard.guardAlert.goToAlertStartLocation = true
		guard.guardAlert.SetAlertTargetLastInfo(wardenCheck.playerRef)

func SetGuardInAlert(guard: GuardController):
	if (!guard.isInAlert && !guard.isStunned):
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		if (guard.isChecking):
			guard.guardCheck.stop_guardCheck()
		if (guard.isInResearch):
			guard.guardResearch.StopResearch()
		guard.guardAlert.start_alert(wardenCheck.playerRef)

func ClearGuardsInArea():
	guardsInArea.clear()

func _on_body_entered(body):
	if (body is GuardController && !guardsInArea.has(body)):
		guardsInArea.push_back(body)

func _on_body_exited(body):
	if (body is GuardController && guardsInArea.has(body)):
		guardsInArea.erase(body)
