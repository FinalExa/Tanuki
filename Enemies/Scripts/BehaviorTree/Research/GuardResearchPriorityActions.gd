extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	PriorityActions()
	return NodeState.RUNNING

func PriorityActions():
	if (guardResearch.isTrackingPriorityTarget):
		TrackPriorityTarget()
		return
	var check: bool = false
	check = HelpStunnedGuards()
	if (!check):
		InvestigateSuspiciousObjects()

func HelpStunnedGuards():
	if (guardResearch.stunnedGuardsList.size()>0):
		if (guardResearch.researchTarget != guardResearch.stunnedGuardsList[0]):
			guardResearch.researchTarget = guardResearch.stunnedGuardsList[0]
			guardResearch.set_research_target(guardResearch.researchTarget.global_position)
		if (enemyController.global_position.distance_to(guardResearch.researchLastPosition) <= guardResearch.stunnedGuardsThresholdDistance):
			guardResearch.guardMovement.set_location_target(enemyController.global_position)
			var id: int = 0
			for i in guardResearch.stunnedGuardsList[0].guardsLookingForMe.size():
				if (guardResearch.stunnedGuardsList[0].guardsLookingForMe[i] == guardResearch):
					id = i
					break
			guardResearch.stunnedGuardsList[0].guardsLookingForMe.remove_at(id)
			guardResearch.stunnedGuardsList[0].guardStunned.end_stun()
			guardResearch.stunnedGuardsList.remove_at(0)
		return true
	return false

func InvestigateSuspiciousObjects():
	if (guardResearch.suspiciousItemsList.size() > 0):
		if (guardResearch.researchTarget != guardResearch.suspiciousItemsList[0]):
			guardResearch.researchTarget = guardResearch.suspiciousItemsList[0]
			guardResearch.set_research_target(guardResearch.researchTarget.global_position)
		if (enemyController.global_position.distance_to(guardResearch.researchLastPosition) <= guardResearch.suspiciousItemsThresholdDistance):
			enemyController.enemyMovement.set_location_target(enemyController.global_position)
			if (guardResearch.researchTarget is PlayerCharacter):
				var tempPlayerReference: PlayerCharacter = guardResearch.researchTarget
				guardResearch.suspiciousItemsList.remove_at(0)
				tempPlayerReference.transformationChangeRef.DeactivateTransformation()
				guardResearch.StopResearch()
				enemyController.guardAlert.start_alert(tempPlayerReference)

func TrackPriorityTarget():
	if (enemyController.global_position.distance_to(guardResearch.researchLastPosition) > guardResearch.priorityTargetThresholdDistance):
		if (guardResearch.researchTarget is PlayerCharacter && !guardResearch.researchTarget.transformationChangeRef.isTransformed):
			guardResearch.set_research_target(guardResearch.researchLastPosition)
			guardResearch.isTrackingPriorityTarget = true
			return
	guardResearch.isTrackingPriorityTarget = false
