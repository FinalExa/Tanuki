extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(delta):
	if (guardCheck.reductionOverTimeActive == true):
		if (guardCheck.currentAlertValue > 0):
			guardCheck.currentAlertValue = clamp(guardCheck.currentAlertValue - (delta * guardCheck.reductionOverTimeValue), 0, guardCheck.maxAlertValue)
			guardCheck.send_alert_value()
		else:
			guardCheck.end_check()
		return NodeState.SUCCESS
	return NodeState.FAILURE
