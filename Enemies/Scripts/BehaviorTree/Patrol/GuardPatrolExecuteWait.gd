extends GuardNode

@export var guardPatrol: GuardPatrol

func Evaluate(delta):
	return wait_active(delta)

func wait_active(delta):
	if (guardPatrol.isWaiting && !guardPatrol.patrolStopped):
		if (guardPatrol.waitTimer > 0):
			guardPatrol.waitTimer -= delta
			return NodeState.SUCCESS
		else:
			guardPatrol.isWaiting = false
			guardPatrol.set_current_patrol_routine()
	return NodeState.FAILURE
