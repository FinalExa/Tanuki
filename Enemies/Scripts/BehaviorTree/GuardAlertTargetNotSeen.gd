extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.targetNotSeenActive == true):
		if(guardAlert.targetNotSeenTimer > 0):
			guardAlert.targetNotSeenTimer -= delta
		else:
			guardAlert.end_alert()
		return NodeState.FAILURE
	return NodeState.SUCCESS
