class_name GuardAlert
extends Node2D

@export var alertMovementSpeed: float
@export var catchDistanceThreshold: float
@export var catchPreparationDuration: float
@export var targetNotSeenDuration: float
@export var targetNotSeenLastLocationThreshold: float
@export var preChaseDuration: float
@export var searchForMissingTargetDistance: float
@export var rayTargets: Array[Node2D]
@export var alertText: String
var catchPreparationTimer: float
var targetNotSeenTimer: float
var preChaseTimer: float
var catchPreparationActive: bool
var targetNotSeenActive: bool
var chaseStart: bool
var firstLocationReached: bool
var secondLocationReached: bool
var secondLocationTargetCheckLaunched: bool
var lostSightOfPlayer: bool
var alertTarget: Node2D
var lastTargetPosition: Vector2
var lastTargetDirection: Vector2
var extraTargetLocation: Vector2

@export var guardAlertValue: GuardAlertValue
@export var guardController: GuardController
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardResearch: GuardResearch
@export var guardStunned: GuardStunned

func start_alert(target):
	guardAlertValue.updateText(alertText)
	alertTarget = target
	preChaseTimer = preChaseDuration
	chaseStart = false
	guardMovement.set_location_target(guardController.global_position)
	targetNotSeenActive = false
	firstLocationReached = false
	secondLocationReached = false
	secondLocationTargetCheckLaunched = false
	guardController.isInAlert = true

func _physics_process(_delta):
	target_tracker_operations()

func target_tracker_operations():
	if (guardController.isInAlert == true):
		tracker_ray()

func tracker_ray():
	var space_state = guardController.get_world_2d().direct_space_state
	for i in rayTargets.size():
		var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayTargets[i].global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { }):
			if (result.collider == alertTarget):
				if (lostSightOfPlayer == false || (lostSightOfPlayer == true && check_if_player_transformation_status(result.collider) == true)):
					track_target(result.collider)
					return
	target_not_seen(space_state)

func track_target(receivedTarget: Node2D):
	guardRotator.setLookingAtPosition(receivedTarget.global_position)
	firstLocationReached = false
	secondLocationReached = false
	secondLocationTargetCheckLaunched = false
	lostSightOfPlayer = false
	if (chaseStart == true):
		targetNotSeenActive = false
		if (guardController.position.distance_to(receivedTarget.global_position) > catchDistanceThreshold):
			catchPreparationActive = false
			guardMovement.set_movement_speed(alertMovementSpeed)
			guardMovement.set_location_target(receivedTarget.global_position)
		else:
			guardMovement.set_location_target(guardController.global_position)
			if (catchPreparationActive == false):
				start_catch_preparation()
	lastTargetPosition = receivedTarget.global_position
	lastTargetDirection = receivedTarget.velocity
	lastTargetDirection = lastTargetDirection.normalized()

func target_not_seen(space_state):
	catchPreparationActive = false
	lostSightOfPlayer = true
	if (firstLocationReached == false):
		var distance: float = guardController.global_position.distance_to(lastTargetPosition)
		if (distance > targetNotSeenLastLocationThreshold && chaseStart == true):
			set_movement_destination(lastTargetPosition)
		else:
			firstLocationReached = true
	if (firstLocationReached == true && secondLocationReached == false):
		if (secondLocationTargetCheckLaunched == false):
			extraTargetLocation = second_location_target_check(space_state)
		var extraDistance: float = guardController.global_position.distance_to(extraTargetLocation)
		if (extraDistance > targetNotSeenLastLocationThreshold && chaseStart == true):
			set_movement_destination(extraTargetLocation)
		else:
			secondLocationReached = true
	else:
		if (firstLocationReached == true && firstLocationReached == true && targetNotSeenActive == false):
			start_not_seen_timer()

func set_movement_destination(destination: Vector2):
	guardMovement.reset_movement_speed()
	guardMovement.set_location_target(destination)
	guardRotator.setLookingAtPosition(destination)

func second_location_target_check(space_state):
	secondLocationTargetCheckLaunched = true
	var searchPosition: Vector2 = guardController.global_position + (lastTargetDirection * searchForMissingTargetDistance)
	var query = PhysicsRayQueryParameters2D.create(guardController.global_position, searchPosition)
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
			return result.collider.global_position
	return searchPosition

func check_if_player_transformation_status(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.isTransformed == true):
		if (playerRef.transformationChangeRef.localAllowedItemsRef != null):
			if (playerRef.transformationChangeRef.localAllowedItemsRef.allowedObjects.has(playerRef.transformationChangeRef.currentTransformationName)):
				return false
	return true

func start_not_seen_timer():
	targetNotSeenTimer = targetNotSeenDuration
	targetNotSeenActive = true

func start_catch_preparation():
	catchPreparationTimer = catchPreparationDuration
	catchPreparationActive = true

func capture_player():
	print("CAPTURED PLAYER")
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
