extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(delta):
	return research_launch_timer(delta)

func research_launch_timer(delta):
	if (!guardResearch.researchLaunched):
		if (guardResearch.researchLaunchTimer > 0):
			guardResearch.researchLaunchTimer -= delta
		else:
			if (guardResearch.researchTarget is PlayerCharacter):
				guardResearch.set_research_target(guardResearch.researchLastPosition)
			guardResearch.researchLaunched = true
	return NodeState.FAILURE
