class_name WardenAlertArea
extends Area2D

@export var wardenCheck: WardenCheck

func _on_body_entered(body):
	if (body is GuardController):
		SetGuardAlerted(body)
			

func SetGuardAlerted(guard: GuardController):
	if (!guard.isInAlert && !guard.isStunned):
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		if (guard.isChecking):
			guard.guardCheck.stop_guardCheck()
		if (guard.isInResearch):
			guard.guardResearch.StopResearch()
		guard.guardAlert.start_alert(wardenCheck.playerRef)
