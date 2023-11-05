class_name GuardAlert
extends Node

@export var alertMovementSpeed: float
@export var catchDistanceThreshold: float
@export var catchPreparationDuration: float
@export var targetNotSeenDuration: float
@export var targetNotSeenLastLocationThreshold: float
@export var preChaseDuration: float
var catchPreparationTimer: float
var targetNotSeenTimer: float
var preChaseTimer: float
var catchPreparationActive: bool
var targetNotSeenActive: bool
var chaseStart: bool
var alertTarget: Node2D
var lastTargetPosition: Vector2

@export var guardAlertValue: GuardAlertValue
@export var guardController: GuardController
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardResearch: GuardResearch
@export var guardStunned: GuardStunned

func start_alert(target):
	guardAlertValue.updateText("ALERT")
	alertTarget = target
	preChaseTimer = preChaseDuration
	chaseStart = false
	guardMovement.set_movement_speed(0)
	guardController.isInAlert = true

func _physics_process(_delta):
	target_tracker_operations()

func target_tracker_operations():
	if (guardController.isInAlert == true && chaseStart == true):
		tracker_ray()

func tracker_ray():
	var space_state = guardController.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(guardController.position, alertTarget.global_position)
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
		track_target(result.collider)

func track_target(receivedTarget: Node2D):
	if (receivedTarget == alertTarget):
		guardRotator.setLookingAtNode(receivedTarget)
		targetNotSeenActive = false
		if (guardController.position.distance_to(receivedTarget.global_position) > catchDistanceThreshold):
			catchPreparationActive = false
			guardMovement.set_movement_speed(alertMovementSpeed)
			guardMovement.set_location_target(receivedTarget.global_position)
		else:
			guardMovement.set_movement_speed(0)
			guardMovement.set_location_target(guardController.global_position)
			if (catchPreparationActive == false):
				start_catch_preparation()
		lastTargetPosition = receivedTarget.global_position
	else:
		guardMovement.reset_movement_speed()
		catchPreparationActive = false
		var distance: float = guardController.global_position.distance_to(lastTargetPosition)
		if (distance > targetNotSeenLastLocationThreshold):
			guardMovement.set_location_target(lastTargetPosition)
			guardRotator.setLookingAtPosition(lastTargetPosition)
		else:
			if (targetNotSeenActive == false):
				start_not_seen_timer()

func start_not_seen_timer():
	targetNotSeenTimer = targetNotSeenDuration
	targetNotSeenActive = true

func start_catch_preparation():
	catchPreparationTimer = catchPreparationDuration
	catchPreparationActive = true

func capture_player():
	pass

func stop_alert():
	guardController.isInAlert = false
	chaseStart = false
	guardMovement.reset_movement_speed()

func end_alert():
	stop_alert()
	guardResearch.initialize_guard_research(alertTarget, true)

func _on_guard_damaged():
	if (guardController.isInAlert == true):
		stop_alert()
		guardStunned.start_stun()
