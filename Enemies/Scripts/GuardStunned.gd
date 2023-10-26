class_name GuardStunned
extends Node

@export var stunDuration: float
@export var stunEndAlertValue: float
var stunTimer: float

@export var guardController: GuardController
@export var guardCheck: GuardCheck
@export var guardMovement: GuardMovement

func start_stun():
	stunTimer = stunDuration
	guardMovement.set_movement_speed(0)
	guardMovement.set_location_target(guardController.global_position)
	guardController.isStunned = true

func end_stun():
	print("End Stun")
	guardCheck.currentAlertValue = stunEndAlertValue
	guardCheck.resume_check()
