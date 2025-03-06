extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(delta):
	return ResearchLaunchTimer(delta)

func ResearchLaunchTimer(delta):
	if (!guardResearch.researchLaunched):
		if (guardResearch.researchLaunchTimer > 0):
			guardResearch.researchLaunchTimer -= delta
		else:
			SetResearchObjective()
			guardResearch.researchLaunched = true
	return NodeState.FAILURE

func SetResearchObjective():
	if (guardResearch.researchTarget != null && guardResearch.researchTarget is PlayerCharacter):
		guardResearch.set_research_target(guardResearch.researchLastPosition)
		return
	if (guardResearch.researchTarget == null):
		guardResearch.set_research_target(guardResearch.researchLocation)
