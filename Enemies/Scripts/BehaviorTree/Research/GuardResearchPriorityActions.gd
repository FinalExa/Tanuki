extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	priority_actions()
	return NodeState.RUNNING

func priority_actions():
	if (guardResearch.isTrackingPriorityTarget):
		track_priority_target()
	else:
		var check: bool = false
		check = help_guards()
		if (!check):
			check = investigate_objects()
			if (check):
				return

func help_guards():
	if (guardResearch.stunnedGuardsList.size()>0):
		if (guardResearch.researchTarget != guardResearch.stunnedGuardsList[0]):
			guardResearch.researchTarget = guardResearch.stunnedGuardsList[0]
			guardResearch.set_research_target(guardResearch.researchTarget.global_position)
		if (guardController.global_position.distance_to(guardResearch.researchLastPosition) <= guardResearch.stunnedGuardsThresholdDistance):
			guardResearch.guardMovement.set_location_target(guardController.global_position)
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

func investigate_objects():
	if (guardResearch.suspiciousItemsList.size()>0):
		if (guardResearch.researchTarget != guardResearch.suspiciousItemsList[0]):
			guardResearch.researchTarget = guardResearch.suspiciousItemsList[0]
			guardResearch.set_research_target(guardResearch.researchTarget.global_position)
		if (guardController.global_position.distance_to(guardResearch.researchLastPosition) <= guardResearch.suspiciousItemsThresholdDistance):
			guardController.guardMovement.set_location_target(guardController.global_position)
			if (guardResearch.researchTarget is PlayerCharacter):
				var tempPlayerReference: PlayerCharacter = guardResearch.researchTarget
				guardResearch.suspiciousItemsList.remove_at(0)
				tempPlayerReference.transformationChangeRef.deactivate_transformation()
				guardResearch.stop_research()
				guardController.guardAlert.start_alert(tempPlayerReference)
				return true
	return false

func track_priority_target():
	if (guardController.global_position.distance_to(guardResearch.researchLastPosition) > guardResearch.priorityTargetThresholdDistance):
		if (guardResearch.researchTarget is PlayerCharacter && !guardResearch.researchTarget.transformationChangeRef.isTransformed):
			guardResearch.set_research_target(guardResearch.researchLastPosition)
			guardResearch.isTrackingPriorityTarget = true
		else:
			guardResearch.isTrackingPriorityTarget = false
	else:
		guardResearch.isTrackingPriorityTarget = false
