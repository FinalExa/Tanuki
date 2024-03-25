extends GuardNode

@export var guardPatrol: GuardPatrol

func Evaluate(delta):
	return startup(delta)

func startup(delta):
	if (guardPatrol.startupActive == true):
		if (guardPatrol.startupTimer > 0):
			guardPatrol.startupTimer -= delta
			return NodeState.SUCCESS
		else:
			guardPatrol.set_current_patrol_routine()
			guardPatrol.startupActive = false
	return NodeState.FAILURE
