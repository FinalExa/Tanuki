extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(delta):
	if (guardCheck.preCheckActive == false && enemyController.isChecking == true):
		return increase_suspicion_value(delta, guardCheck.selectedMultiplier)

func increase_suspicion_value(delta, multiplier):
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
			if (guardCheck.researchOutcome == true):
				guardCheck.stop_guardCheck()
				enemyController.guardAlert.start_alert(guardCheck.checkTarget)
			else:
				guardCheck.stop_guardCheck()
				enemyController.guardResearch.initialize_guard_research(guardCheck.checkTarget)
			return NodeState.SUCCESS
	return NodeState.FAILURE
