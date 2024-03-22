extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(delta):
	if (!guardController.isInAlert):
		return research_has_found_something(delta)
	return NodeState.FAILURE

func research_has_found_something(delta):
	if (guardController.isInResearch && guardResearch.researchLaunched && !guardResearch.researchHasFoundSomething && guardResearch.stunnedGuardsList.size() == 0 && guardResearch.suspiciousItemsList.size() == 0):
		research_end_timer(delta)
	else:
		guardResearch.reset_research_end_timer()
	return NodeState.SUCCESS

func research_end_timer(delta):
	if (guardResearch.researchEndTimer > 0):
		guardResearch.researchEndTimer -= delta
	else:
		guardResearch.research_to_check()
