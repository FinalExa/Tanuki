extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(delta):
	if (guardCheck.preCheckActive == true && enemyController.isChecking == false):
		return execute_precheck(guardCheck.detectedTarget, delta)
	return NodeState.FAILURE

func execute_precheck(target: Node2D, delta):
	if (guardCheck.preCheckTimer>0):
		guardCheck.preCheckTimer -= delta
		return NodeState.SUCCESS
	else:
		guardCheck.activate_check(target)
	return NodeState.FAILURE
