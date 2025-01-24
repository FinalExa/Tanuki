extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(delta):
	if (!guardCheck.preCheckActive && enemyController.isChecking):
		return IncreaseSuspicionValue(delta, guardCheck.selectedMultiplier)
	return NodeState.SUCCESS

func IncreaseSuspicionValue(delta, multiplier):
	if (guardCheck.checkTarget != null):
		var distance: float = enemyController.position.distance_to(guardCheck.checkTarget.position)
		var multValue: float = guardCheck.designatedTargetDistance - distance
		if (multValue < guardCheck.minimumIncreaseValue):
			multValue = guardCheck.minimumIncreaseValue
		multValue = multValue * guardCheck.distanceMultiplier * multiplier * delta
		if (guardCheck.currentAlertValue < guardCheck.maxAlertValue):
			guardCheck.currentAlertValue = clamp(guardCheck.currentAlertValue + multValue, 0, guardCheck.maxAlertValue)
			guardCheck.send_alert_value()
			return NodeState.FAILURE
		else:
			guardCheck.stop_guardCheck()
			if (guardCheck.researchOutcome):
				enemyController.guardAlert.start_alert(guardCheck.checkTarget)
			else:
				enemyController.guardResearch.StartResearchWithSuspiciousItem(guardCheck.checkTarget)
			return NodeState.SUCCESS
	return NodeState.FAILURE
