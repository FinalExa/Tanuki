class_name CallGuardHitbox
extends Area2D

var targetObject: Node2D

func _on_body_entered(body):
	if (body is GuardController):
		var guardRef: GuardController = body
		if (!guardRef.isInResearch && !guardRef.isInAlert && !guardRef.isStunned):
			print("ciao")
			guardRef.guardResearch.initialize_guard_research(targetObject)
