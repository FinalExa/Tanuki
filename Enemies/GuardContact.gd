extends Area2D

@export var guardController: GuardController
@export var guardRotator: GuardRotator
@export var checkValue: float

func _on_body_entered(body):
	if (body is PlayerCharacter && body.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
		if (guardController.isInAlert):
			guardController.guardAlert.set_last_target_info(body)
			return
		if (guardController.isInResearch):
			guardController.guardResearch.spot_player_from_afar(body)
			return
		if (!guardController.isChecking && guardController.isInPatrol):
				guardController.guardCheck.activate_check(body)
		if (guardController.isChecking && guardController.guardCheck.currentAlertValue < checkValue):
			guardController.guardCheck.currentAlertValue = checkValue
		guardRotator.setLookingAtPosition(body.global_position)
