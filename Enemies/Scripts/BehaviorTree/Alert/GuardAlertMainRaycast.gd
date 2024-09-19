extends GuardNode

@export var guardAlert: GuardAlert

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	AlertOperations()
	return state

func AlertOperations():
	state = NodeState.FAILURE
	for i in guardAlert.raycastResult.size():
		if (AnalyzeResult(guardAlert.raycastResult[i])):
			state = NodeState.SUCCESS
			return

func AnalyzeResult(result):
	if (result != null && result == guardAlert.alertTarget):
		TargetIsTail()
		if (TargetIsVisible(result)): return true
		if (BackToResearch()): return true
	return false

func TargetIsTail():
	if (guardAlert.alertTarget is TailFollow):
		guardAlert.alertTarget = guardAlert.alertTarget.playerRef

func TargetIsVisible(result):
	if (!guardAlert.lostSightOfPlayer || (guardAlert.lostSightOfPlayer && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 0)):
		TrackTarget(result)
		return true
	return false

func BackToResearch():
	if (guardAlert.lostSightOfPlayer && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
		guardAlert.stop_alert()
		enemyController.guardResearch.initialize_guard_research(guardAlert.alertTarget)
		return true
	return false

func TrackTarget(receivedTarget: Node2D):
	enemyController.enemyRotator.setLookingAtPosition(receivedTarget.global_position)
	guardAlert.firstLocationReached = false
	guardAlert.secondLocationReached = false
	guardAlert.secondLocationTargetCheckLaunched = false
	guardAlert.lostSightOfPlayer = false
	if (receivedTarget is PlayerCharacter):
		guardAlert.SetAlertTargetLastInfo(receivedTarget)
	else:
		if (receivedTarget is TailFollow):
			guardAlert.SetAlertTargetLastInfo(receivedTarget.playerRef)
	if (guardAlert.chaseStart):
		guardAlert.targetNotSeenActive = false
		if (enemyController.position.distance_to(receivedTarget.global_position) > guardAlert.catchDistanceThreshold):
			guardAlert.catchPreparationActive = false
			enemyController.enemyMovement.set_movement_speed(guardAlert.alertMovementSpeed)
			enemyController.enemyMovement.set_location_target(receivedTarget.global_position)
		else:
			enemyController.enemyMovement.set_location_target(enemyController.global_position)
			if (!guardAlert.catchPreparationActive):
				StartCatchPlayer()

func StartCatchPlayer():
	guardAlert.catchPreparationTimer = guardAlert.catchPreparationDuration
	guardAlert.catchPreparationActive = true
