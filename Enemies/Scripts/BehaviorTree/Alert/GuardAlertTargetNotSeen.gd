extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.targetNotSeenActive == true):
		if(guardAlert.targetNotSeenTimer > 0):
			guardAlert.targetNotSeenTimer -= delta
		else:
			guardAlert.stop_alert()
			enemyController.guardCheck.currentAlertValue = guardAlert.returnToCheckAlertValue
			enemyController.enemyPatrol.select_new_patrol_indicator()
			enemyController.guardCheck.resume_check()
		return NodeState.FAILURE
	return NodeState.SUCCESS
