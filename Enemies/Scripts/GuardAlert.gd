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

func start_alert(target):
	guardAlertValue.updateText("ALERT")
	alertTarget = target
	preChaseTimer = preChaseDuration
	guardMovement.set_movement_speed(alertMovementSpeed)
	guardRotator.setLookingAtNode(alertTarget)
	guardController.isInAlert = true

func _process(delta):
	alert_timer_checks(delta)

func alert_timer_checks(delta):
	if(guardController.isInAlert == true):
		chase_start(delta)
		catch_preparation(delta)
		target_not_seen(delta)

func _physics_process(delta):
	target_tracker_operations(delta)

func target_tracker_operations(delta):
	if (guardController.isInAlert == true):
		if (chaseStart == true):
			tracker_ray(delta)

func tracker_ray(delta):
	var space_state = guardController.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(guardController.position, alertTarget.global_position)
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
		track_target(result.collider, delta)

func track_target(receivedTarget: Node2D, delta):
	if (receivedTarget == alertTarget):
		guardRotator.setLookingAtNode(receivedTarget)
		targetNotSeenActive = false
		if (guardController.position.distance_to(receivedTarget.global_position) > catchDistanceThreshold):
			catchPreparationActive = false
			guardMovement.set_movement_speed(alertMovementSpeed)
			guardMovement.set_location_target(receivedTarget.global_position)
		else:
			guardMovement.set_movement_speed(0)
			if (catchPreparationActive == false):
				start_catch_preparation()
		lastTargetPosition = receivedTarget.global_position
	else:
		if (guardController.position.distance_to(receivedTarget.global_position) > targetNotSeenLastLocationThreshold):
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

func catch_preparation(delta):
	if (catchPreparationActive == true):
		if(catchPreparationTimer > 0):
			catchPreparationTimer -= delta
		else:
			capture_player()

func target_not_seen(delta):
	if (targetNotSeenActive == true):
		if(targetNotSeenTimer > 0):
			targetNotSeenActive -= delta
		else:
			end_alert()

func chase_start(delta):
	if (chaseStart == false):
		if (preChaseTimer > 0):
			preChaseTimer -= delta
		else:
			chaseStart = true

func capture_player():
	print("PLAYER CAPTURED")

func end_alert():
	guardController.isInAlert = false
	chaseStart = false
	guardResearch.initialize_guard_research(alertTarget, true)
