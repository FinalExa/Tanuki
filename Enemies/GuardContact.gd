extends Area2D

@export var guardController: GuardController
@export var guardRotator: GuardRotator

func _on_body_entered(body):
	if (body is PlayerCharacter && body.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
		if (!guardController.isInAlert && !guardController.isInResearch && !guardController.isChecking && guardController.isInPatrol):
			guardController.guardPatrol.stop_patrol()
			guardRotator.setLookingAtPosition(body.global_position)
