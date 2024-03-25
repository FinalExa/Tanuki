extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(_delta):
	return body_checks()

func body_checks():
	if (guardCheck.checkActive):
		if (guardCheck.playerInsideCheckHitbox && !guardCheck.checkWithRayCast):
			guardCheck.checkWithRayCast = true
			guardCheck.reductionOverTimeActive = false
			return NodeState.FAILURE
		if (!guardCheck.playerInsideCheckHitbox):
				return determine_if_end_check(guardCheck.bodySave)

func determine_if_end_check(_body):
	if (guardController.isChecking == false):
		guardCheck.checkWithRayCast = false
		guardCheck.preCheckActive = false
		return NodeState.SUCCESS
	else:
		if (guardCheck.currentAlertValue >= guardCheck.researchValueThreshold):
			guardCheck.stop_guardCheck()
			guardController.guardResearch.initialize_guard_research(guardCheck.checkTarget)
			return NodeState.SUCCESS
		else:
			if (guardCheck.reductionOverTimeActive == false):
				guardCheck.activate_reduction_over_time()
				return NodeState.FAILURE
