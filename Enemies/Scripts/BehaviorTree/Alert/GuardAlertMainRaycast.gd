extends GuardNode

@export var guardAlert: GuardAlert

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	alert_operations()
	return state

func alert_operations():
	if (guardAlert.chaseStart && guardAlert.screamAreaInstance != null):
		guardAlert.remove_area()
	main_alert_operation()
	state = NodeState.SUCCESS

func main_alert_operation():
	for i in guardAlert.raycastResult.size():
		if (guardAlert.raycastResult[i] != null):
			if (guardAlert.raycastResult[i] == guardAlert.alertTarget):
				if (guardAlert.alertTarget is TailFollow):
					guardAlert.alertTarget = guardAlert.alertTarget.playerRef
				if (!guardAlert.lostSightOfPlayer || (guardAlert.lostSightOfPlayer && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 0)):
					track_target(guardAlert.raycastResult[i])
					return
				else:
					if (guardAlert.lostSightOfPlayer == true && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
						guardAlert.stop_alert()
						guardController.guardResearch.initialize_guard_research(guardAlert.alertTarget)
						return
	target_not_seen()

func track_target(receivedTarget: Node2D):
	guardController.guardRotator.setLookingAtPosition(receivedTarget.global_position)
	guardAlert.firstLocationReached = false
	guardAlert.secondLocationReached = false
	guardAlert.secondLocationTargetCheckLaunched = false
	guardAlert.lostSightOfPlayer = false
	if (receivedTarget is PlayerCharacter):
		guardAlert.set_last_target_info(receivedTarget)
	else:
		if (receivedTarget is TailFollow):
			guardAlert.set_last_target_info(receivedTarget.playerRef)
	if (guardAlert.chaseStart):
		guardAlert.targetNotSeenActive = false
		if (guardController.position.distance_to(receivedTarget.global_position) > guardAlert.catchDistanceThreshold):
			guardAlert.catchPreparationActive = false
			guardController.guardMovement.set_movement_speed(guardAlert.alertMovementSpeed)
			guardController.guardMovement.set_location_target(receivedTarget.global_position)
		else:
			guardController.guardMovement.set_location_target(guardController.global_position)
			if (!guardAlert.catchPreparationActive):
				guardAlert.start_catch_preparation()

func target_not_seen():
	guardAlert.catchPreparationActive = false
	guardAlert.lostSightOfPlayer = true
	if (!guardAlert.firstLocationReached):
		var distance: float = guardController.global_position.distance_to(guardAlert.lastTargetPosition)
		if (distance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
			guardAlert.set_movement_destination(guardAlert.lastTargetPosition)
		else:
			guardAlert.firstLocationReached = true
	if (guardAlert.firstLocationReached && !guardAlert.secondLocationReached):
		if (guardAlert.secondLocationTargetCheckLaunched == false):
			guardAlert.secondLocationTargetCheckLaunched = true
			guardAlert.extraLocationSet = false
		var extraDistance: float = guardController.global_position.distance_to(guardAlert.extraTargetLocation)
		if (extraDistance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
			guardAlert.set_movement_destination(guardAlert.extraTargetLocation)
		else:
			guardAlert.secondLocationReached = true
	else:
		if (guardAlert.firstLocationReached && guardAlert.secondLocationReached && !guardAlert.targetNotSeenActive):
			guardAlert.start_not_seen_timer()
