class_name CallGuardHitbox
extends Area2D

var targetObject: PlayerCharacter

func _on_body_entered(body):
	if (body is GuardController):
		var guardRef: GuardController = body
		if (!guardRef.isInAlert && !guardRef.isStunned):
			if (guardRef.isInPatrol):
				guardRef.guardPatrol.stop_patrol()
			if (guardRef.isChecking):
				guardRef.guardCheck.stop_guardCheck()
			if (guardRef.isInResearch):
				guardRef.guardResearch.stop_research()
			guardRef.guardAlert.start_alert(targetObject)
			guardRef.guardAlert.set_movement_destination(targetObject.global_position)
