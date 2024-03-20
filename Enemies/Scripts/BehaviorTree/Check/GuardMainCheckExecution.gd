extends GuardNode

@export var guardCheck: GuardCheck

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	return state

func _physics_process(_delta):
	check_with_raycast()

func check_with_raycast():
	if (guardCheck.checkActive == true && guardCheck.checkWithRayCast == true):
		var space_state = guardCheck.get_world_2d().direct_space_state
		for i in guardCheck.rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.position, guardCheck.rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { } && (result.collider is PlayerCharacter || result.collider is TailFollow)): 
				determine_suspicion_type_with_conditions(result.collider)
				break
	else:
		state = NodeState.FAILURE

func determine_suspicion_type_with_conditions(target):
	if (guardCheck.checkActive == true):
		determine_suspicion_type(target)

func determine_suspicion_type(target):
	if (target is PlayerCharacter):
		if(target.transformationChangeRef.isTransformed == false):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsSeenMultiplier)
			guardCheck.researchOutcome = true
			return
		if (target.velocity != Vector2.ZERO):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		var localAllowRef: LocalAllowedItems = target.transformationChangeRef.localAllowedItemsRef
		if (localAllowRef == null || (localAllowRef != null && !localAllowRef.allowedObjects.has(target.transformationChangeRef.currentTransformationName))):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (guardCheck.playerSeen):
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
	if (target is TailFollow):
		guardCheck.playerSeen = true
		suspicion_active(target, guardCheck.playerIsSeenMultiplier)
		guardCheck.researchOutcome = true

func suspicion_active(target: Node2D, multiplier):
	if (guardCheck.reductionOverTimeActive == true):
		guardCheck.reductionOverTimeActive = false
	if (guardCheck.preCheckActive == false && guardController.isChecking == false):
		guardCheck.activate_preCheck(target, multiplier)
		state = NodeState.SUCCESS
