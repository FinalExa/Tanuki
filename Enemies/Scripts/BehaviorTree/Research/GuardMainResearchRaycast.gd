extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	if (guardResearch.researchLaunched):
		research_main_raycast()
		return NodeState.SUCCESS
	else:
		return NodeState.FAILURE

func research_main_raycast():
	for i in guardResearch.mainRaycastResult.size():
		if (guardResearch.mainRaycastResult[i] != null):
			spotting_operations(guardResearch.mainRaycastResult[i])
			if (enemyController.isInAlert):
				return

func spotting_operations(trackedObject: Node2D):
	var spotting_result: bool = false
	spotting_result = player_detection(trackedObject)
	if (spotting_result):
		guardResearch.stop_research()
		return
	spotting_result = stunned_guards_detection(trackedObject)
	if (spotting_result):
		return
	spotting_result = suspicious_objects_detection(trackedObject)
	return

func player_detection(trackedObject: Node2D):
	if ((trackedObject is PlayerCharacter &&
	trackedObject.transformationChangeRef.isTransformed == false) ||
	trackedObject is TailFollow):
		if (trackedObject is PlayerCharacter):
			enemyController.guardAlert.start_alert(trackedObject)
		else:
			enemyController.guardAlert.start_alert(trackedObject.playerRef)
		return true
	return false

func suspicious_objects_detection(trackedObject: Node2D):
	if (trackedObject is PlayerCharacter &&
		trackedObject.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
		if (!guardResearch.suspiciousItemsList.has(trackedObject)):
			guardResearch.suspiciousItemsList.push_back(trackedObject)
			if (!trackedObject.transformationChangeRef.guardsLookingForMe.has(guardResearch)):
				trackedObject.transformationChangeRef.guardsLookingForMe.push_back(guardResearch)
		return true
	return false

func stunned_guards_detection(trackedObject: Node2D):
	if (trackedObject is GuardController &&
		trackedObject.isStunned &&
		trackedObject != enemyController):
			if (!search_object_in_list(trackedObject, guardResearch.stunnedGuardsList)):
				guardResearch.stunnedGuardsList.push_back(trackedObject)
				if (!search_object_in_list(guardResearch, trackedObject.guardsLookingForMe)):
					trackedObject.guardsLookingForMe.push_back(guardResearch)
			return true
	return false

func search_object_in_list(objectToSearch, list):
	for i in list.size():
		if (list[i] == objectToSearch):
			return true
	return false
