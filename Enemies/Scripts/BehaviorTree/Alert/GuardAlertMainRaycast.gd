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
		if (TargetIsVisible()): return true
		if (BackToResearch()): return true
	return false

func TargetIsVisible():
	if (!guardAlert.lostSightOfPlayer || (guardAlert.lostSightOfPlayer && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 0)):
		TrackTarget()
		return true
	return false

func BackToResearch():
	if (!guardAlert.lostSightOfPlayer && guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
		guardAlert.stop_alert()
		enemyController.guardResearch.StartResearchWithSuspiciousItem(guardAlert.alertTarget)
		return true
	return false

func TrackTarget():
	SetTrackData()
	AlertChase()

func SetTrackData():
	enemyController.enemyRotator.setLookingAtPosition(guardAlert.alertTarget.global_position)
	guardAlert.firstLocationReached = false
	guardAlert.secondLocationReached = false
	guardAlert.secondLocationTargetCheckLaunched = false
	guardAlert.lostSightOfPlayer = false
	guardAlert.SetAlertTargetLastInfo(guardAlert.alertTarget)

func AlertChase():
	if (guardAlert.chaseStart):
		guardAlert.targetNotSeenActive = false
		if (enemyController.position.distance_to(guardAlert.alertTarget.global_position) > guardAlert.catchDistanceThreshold):
			FollowPlayer(guardAlert.alertTarget)
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
