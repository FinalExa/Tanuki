extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.chaseStart == false):
		print("prechase")
		if (guardAlert.preChaseTimer > 0):
			guardAlert.preChaseTimer -= delta
			return NodeState.FAILURE
		else:
			guardAlert.chaseStart = true
	return NodeState.SUCCESS
