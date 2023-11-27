class_name GuardStunned
extends Node

@export var stunDuration: float
@export var stunEndAlertValue: float
var stunTimer: float

@export var guardController: GuardController
@export var guardCheck: GuardCheck
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardAlertValue: GuardAlertValue

func start_stun():
	stunTimer = stunDuration
	guardMovement.set_location_target(guardController.global_position)
	guardRotator.setLookingAtPosition((guardController.up_direction * 10) + guardController.global_position)
	guardAlertValue.updateText("STUNNED")
	guardController.isStunned = true

func end_stun():
	guardCheck.currentAlertValue = stunEndAlertValue
	clear_guards_looking_for_me()
	guardController.isStunned = false
	guardCheck.resume_check()

func clear_guards_looking_for_me():
	for i in guardController.guardsLookingForMe.size():
		for y in guardController.guardsLookingForMe[i].stunnedGuardsList.size():
			if (guardController.guardsLookingForMe[i].stunnedGuardsList[y] == guardController):
				guardController.guardsLookingForMe[i].stunnedGuardsList.remove_at(y)
				break
	guardController.guardsLookingForMe.clear()
