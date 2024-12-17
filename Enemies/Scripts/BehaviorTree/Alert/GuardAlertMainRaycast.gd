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
		if (TargetIsVisible(result)): return true
		if (BackToResearch()): return true
	return false

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
	SetTrackData(receivedTarget)
	TargetType(receivedTarget)
	AlertChase(receivedTarget)

func SetTrackData(receivedTarget: Node2D):
	enemyController.enemyRotator.setLookingAtPosition(receivedTarget.global_position)
	guardAlert.firstLocationReached = false
	guardAlert.secondLocationReached = false
	guardAlert.secondLocationTargetCheckLaunched = false
	guardAlert.lostSightOfPlayer = false

func TargetType(receivedTarget: Node2D):
	if (receivedTarget is PlayerCharacter):
		guardAlert.SetAlertTargetLastInfo(receivedTarget)

func AlertChase(receivedTarget: Node2D):
	if (guardAlert.chaseStart):
		guardAlert.targetNotSeenActive = false
		guardAlert.goToAlertStartLocation = false
		if (enemyController.position.distance_to(receivedTarget.global_position) > guardAlert.catchDistanceThreshold):
			FollowPlayer(receivedTarget)
			return
		CatchPlayer()

func FollowPlayer(receivedTarget: Node2D):
	guardAlert.catchPreparationActive = false
	enemyController.enemyMovement.set_movement_speed(guardAlert.alertMovementSpeed)
	enemyController.enemyMovement.set_location_target(receivedTarget.global_position)

func CatchPlayer():
	enemyController.enemyMovement.set_new_target(null)
	if (!guardAlert.catchPreparationActive):
		guardAlert.catchPreparationTimer = guardAlert.catchPreparationDuration
		guardAlert.catchPreparationActive = true
