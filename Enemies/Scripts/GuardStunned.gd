class_name GuardStunned
extends Node

@export var stunDuration: float
@export var stunEndAlertValue: float
@export var stunnedText: String
var stunTimer: float
var stunnedFromAlert: bool = false

@export var guardController: GuardController

var lookDirectionAfterStun: Vector2

func start_stun(direction: Vector2):
	stunTimer = stunDuration
	lookDirectionAfterStun = direction
	guardController.guardMovement.set_location_target(guardController.global_position)
	guardController.guardAlertValue.updateText(stunnedText)
	guardController.isStunned = true
	if (stunnedFromAlert):
		guardController.guardPatrol.select_new_patrol_indicator()
		stunnedFromAlert = false

func end_stun():
	clear_guards_looking_for_me()
	guardController.guardRotator.setLookingAtPosition((lookDirectionAfterStun * 10) + guardController.global_position)
	guardController.isStunned = false
	guardController.guardCheck.currentAlertValue = stunEndAlertValue
	guardController.guardCheck.resume_check()

func clear_guards_looking_for_me():
	for i in guardController.guardsLookingForMe.size():
		for y in guardController.guardsLookingForMe[i].stunnedGuardsList.size():
			if (guardController.guardsLookingForMe[i].stunnedGuardsList[y] == guardController):
				guardController.guardsLookingForMe[i].stunnedGuardsList.remove_at(y)
				break
	guardController.guardsLookingForMe.clear()
