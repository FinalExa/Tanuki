extends Area2D

@export var guardController: GuardController
@export var guardRotator: GuardRotator
@export var checkValue: float

func _on_body_entered(body):
	if (body is PlayerCharacter && body.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
		if (!guardController.isStunned):
			guardRotator.setLookingAtPosition(body.global_position)
		if (guardController.isInAlert):
			guardController.guardAlert.lastTargetPosition = body.global_position
			guardController.guardAlert.extraTargetLocation = body.global_position
			return
		if (!guardController.isChecking && guardController.isInPatrol):
			guardController.guardMovement.set_new_target(null)
		if (guardController.guardCheck.currentAlertValue < checkValue):
			guardController.guardCheck.currentAlertValue = checkValue
