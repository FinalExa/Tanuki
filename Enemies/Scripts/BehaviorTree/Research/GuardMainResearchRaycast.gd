extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	return state

func _physics_process(_delta):
	research_main_raycast()
	state = NodeState.SUCCESS

func research_main_raycast():
	if (guardController.isInResearch && guardResearch.researchLaunched):
		var spaceState = guardController.get_world_2d().direct_space_state
		for i in guardResearch.rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, guardResearch.rayTargets[i].global_position)
			var result = spaceState.intersect_ray(query)
			if (result && result != { }):
				guardResearch.researchHasFoundSomething = spotting_operations(result.collider)
				if (guardController.isInAlert):
					return

func spotting_operations(trackedObject: Node2D):
	var spotting_result: bool = false
	spotting_result = player_detection(trackedObject)
	if (spotting_result):
		guardResearch.stop_research()
		return spotting_result
	spotting_result = stunned_guards_detection(trackedObject)
	if (spotting_result):
		return spotting_result
	spotting_result = suspicious_objects_detection(trackedObject)
	return spotting_result

func player_detection(trackedObject: Node2D):
	if ((trackedObject is PlayerCharacter &&
	trackedObject.transformationChangeRef.isTransformed == false) ||
	trackedObject is TailFollow):
		if (trackedObject is PlayerCharacter):
			guardController.guardAlert.start_alert(trackedObject)
		else:
			guardController.guardAlert.start_alert(trackedObject.playerRef)
		return true
	return false

func suspicious_objects_detection(trackedObject: Node2D):
	if (trackedObject is PlayerCharacter &&
		trackedObject.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
		if (!guardResearch.suspiciousItemsList.has(trackedObject)):
			guardResearch.suspiciousItemsList.push_back(trackedObject)
			if (!trackedObject.transformationChangeRef.guardsLookingForMe.has(self)):
				trackedObject.transformationChangeRef.guardsLookingForMe.push_back(self)
		return true
	return false

func stunned_guards_detection(trackedObject: Node2D):
	if (trackedObject is GuardController &&
		trackedObject.isStunned &&
		trackedObject != guardController):
			if (!guardResearch.stunnedGuardsList.has(trackedObject)):
				guardResearch.stunnedGuardsList.push_back(trackedObject)
				if (!trackedObject.guardsLookingForMe.has(self)):
					trackedObject.guardsLookingForMe.push_back(self)
			return true
	return false
