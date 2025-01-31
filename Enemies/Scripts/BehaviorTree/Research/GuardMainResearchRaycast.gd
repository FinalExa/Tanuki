extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	if (guardResearch.researchLaunched):
		AnalyzeResearchMainRaycast()
		return NodeState.SUCCESS
	else:
		return NodeState.FAILURE

func AnalyzeResearchMainRaycast():
	for i in guardResearch.mainRaycastResult.size():
		if (guardResearch.mainRaycastResult[i] != null):
			SpotOperations(guardResearch.mainRaycastResult[i])
			if (enemyController.isInAlert):
				return

func SpotOperations(trackedObject: Node2D):
	var spotting_result: bool = false
	spotting_result = PlayerDetect(trackedObject)
	if (spotting_result):
		return
	spotting_result = StunnedGuardsDetect(trackedObject)
	if (spotting_result):
		return
	spotting_result = SuspiciousObjectsDetect(trackedObject)
	return

func PlayerDetect(trackedObject: Node2D):
	if (trackedObject is PlayerCharacter):
		var playerValue: int = trackedObject.transformationChangeRef.get_if_transformed_in_right_zone()
		if (playerValue == 0):
			guardResearch.StopResearch()
			enemyController.guardAlert.start_alert(trackedObject)
			return true
		if (playerValue == 2 || trackedObject.velocity != Vector2.ZERO):
			guardResearch.set_research_target(trackedObject.global_position)
			guardResearch.isTrackingPriorityTarget = true
	return false

func SuspiciousObjectsDetect(trackedObject: Node2D):
	if (trackedObject is PlayerCharacter &&
		trackedObject.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
		if (!guardResearch.suspiciousItemsList.has(trackedObject)):
			guardResearch.suspiciousItemsList.push_back(trackedObject)
			if (!trackedObject.transformationChangeRef.guardsLookingForMe.has(guardResearch)):
				trackedObject.transformationChangeRef.guardsLookingForMe.push_back(guardResearch)
		return true
	return false

func StunnedGuardsDetect(trackedObject: Node2D):
	if (trackedObject is GuardController &&
		trackedObject.isStunned &&
		trackedObject != enemyController):
			if (!guardResearch.stunnedGuardsList.has(trackedObject)):
				guardResearch.stunnedGuardsList.push_back(trackedObject)
				if (!trackedObject.guardsLookingForMe.has(guardResearch)):
					trackedObject.guardsLookingForMe.push_back(guardResearch)
			return true
	return false
