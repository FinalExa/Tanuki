extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.targetNotSeenActive == true):
		if(guardAlert.targetNotSeenTimer > 0):
			guardAlert.targetNotSeenTimer -= delta
		else:
			guardAlert.stop_alert()
			guardController.guardCheck.currentAlertValue = guardAlert.returnToCheckAlertValue
			guardController.guardPatrol.select_new_patrol_indicator()
			guardController.guardCheck.resume_check()
		return NodeState.FAILURE
	return NodeState.SUCCESS
