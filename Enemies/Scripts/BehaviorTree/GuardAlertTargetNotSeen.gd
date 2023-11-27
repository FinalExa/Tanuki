extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.targetNotSeenActive == true):
		if(guardAlert.targetNotSeenTimer > 0):
			guardAlert.targetNotSeenTimer -= delta
		else:
			guardAlert.stop_alert()
			guardAlert.guardCheck.currentAlertValue = guardAlert.returnToCheckAlertValue
			guardAlert.guardCheck.resume_check()
		return NodeState.FAILURE
	return NodeState.SUCCESS
