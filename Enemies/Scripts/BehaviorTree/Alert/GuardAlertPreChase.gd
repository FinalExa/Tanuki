extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (!guardAlert.chaseStart):
		if (guardAlert.preChaseTimer > 0):
			guardAlert.preChaseTimer -= delta
		else:
			guardAlert.screamArea.SetReducedAreaSize()
			guardAlert.chaseStart = true
	return NodeState.SUCCESS
