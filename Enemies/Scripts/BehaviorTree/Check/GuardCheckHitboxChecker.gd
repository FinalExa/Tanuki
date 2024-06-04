extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(_delta):
	return body_checks()

func body_checks():
	if (guardCheck.checkActive):
		if (guardCheck.playerInsideCheckHitbox):
			if (!guardCheck.checkWithRayCast):
				guardCheck.checkWithRayCast = true
			return NodeState.FAILURE
	if (!guardCheck.playerInsideCheckHitbox):
		return determine_if_end_check(guardCheck.bodySave)

func determine_if_end_check(_body):
	guardCheck.checkWithRayCast = false
	if (!enemyController.isChecking):
		guardCheck.preCheckActive = false
		return NodeState.SUCCESS
	else:
		if (guardCheck.currentAlertValue >= guardCheck.researchValueThreshold):
			guardCheck.stop_guardCheck()
			enemyController.guardResearch.initialize_guard_research(guardCheck.checkTarget)
			return NodeState.SUCCESS
		else:
			if (!guardCheck.reductionOverTimeActive):
				guardCheck.activate_reduction_over_time()
	return NodeState.FAILURE
