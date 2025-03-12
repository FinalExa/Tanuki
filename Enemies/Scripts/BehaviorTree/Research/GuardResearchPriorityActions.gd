extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	PriorityActions()
	return NodeState.RUNNING

func PriorityActions():
	if (guardResearch.isTrackingPriorityTarget):
		TrackPriorityTarget()
		return
	InvestigateSuspiciousObjects()

func InvestigateSuspiciousObjects():
	if (guardResearch.suspiciousItemsList.size() > 0):
		if (guardResearch.researchTarget != guardResearch.suspiciousItemsList[0]):
			guardResearch.researchTarget = guardResearch.suspiciousItemsList[0]
			guardResearch.set_research_target(guardResearch.researchTarget.global_position)
		if (enemyController.global_position.distance_to(guardResearch.researchLastPosition) <= guardResearch.suspiciousItemsThresholdDistance):
			enemyController.enemyMovement.set_location_target(enemyController.global_position)
			if (guardResearch.researchTarget is PlayerCharacter):
				Uncover(guardResearch.researchTarget)

func TrackPriorityTarget():
	if (guardResearch.researchTarget is PlayerCharacter):
		if (enemyController.global_position.distance_to(guardResearch.researchLastPosition) > guardResearch.priorityTargetThresholdDistance):
			guardResearch.set_research_target(guardResearch.researchLastPosition)
			guardResearch.isTrackingPriorityTarget = true
			return
		if (guardResearch.playerWasSpottedTransformed):
			Uncover(guardResearch.researchTarget)
		return
	guardResearch.isTrackingPriorityTarget = false

func Uncover(ref: PlayerCharacter):
	if (guardResearch.suspiciousItemsList.has(ref)):
		guardResearch.suspiciousItemsList.erase(ref)
	ref.transformationChangeRef.DeactivateTransformation()
	guardResearch.StopResearch()
	enemyController.guardAlert.start_alert(ref)
