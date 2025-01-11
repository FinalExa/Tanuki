extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(delta):
	if (guardCheck.preCheckActive && !enemyController.isChecking):
		return PreCheck(guardCheck.detectedTarget, delta)
	return NodeState.FAILURE

func PreCheck(target: Node2D, delta):
	if (guardCheck.preCheckTimer > 0):
		guardCheck.preCheckTimer -= delta
		return NodeState.SUCCESS
	else:
		guardCheck.activate_check(target)
	return NodeState.FAILURE
