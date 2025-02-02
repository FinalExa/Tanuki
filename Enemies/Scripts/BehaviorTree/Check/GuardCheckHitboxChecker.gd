extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(_delta):
	return body_checks()

func body_checks():
	if (guardCheck.checkActive && guardCheck.playerInsideCheckHitbox):
		if (!guardCheck.checkWithRayCast):
			guardCheck.checkWithRayCast = true
		return NodeState.FAILURE
	if (!guardCheck.playerInsideCheckHitbox):
		return DetermineIfCheckEnds(guardCheck.bodySave)
	return NodeState.SUCCESS

func DetermineIfCheckEnds(_body):
	guardCheck.checkWithRayCast = false
	if (!enemyController.isChecking):
		guardCheck.preCheckActive = false
		return NodeState.SUCCESS
	if (guardCheck.currentAlertValue >= guardCheck.researchValueThreshold):
		guardCheck.StopCheck()
		enemyController.guardResearch.initialize_guard_research(guardCheck.checkTarget)
		return NodeState.SUCCESS
	if (!guardCheck.reductionOverTimeActive):
		guardCheck.ActivateReduction()
	return NodeState.FAILURE
