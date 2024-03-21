extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(delta):
	if(guardResearch.buildUpActive == true):
		if (guardResearch.buildUpTimer > 0):
			guardResearch.buildUpTimer-=delta
		else:
			guardResearch.buildUpActive = false
			guardResearch.buildup_results()
	return NodeState.FAILURE
