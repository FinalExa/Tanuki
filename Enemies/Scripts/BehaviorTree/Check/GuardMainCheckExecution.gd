extends GuardNode

@export var guardCheck: GuardCheck

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	main_check()
	return state

func main_check():
	if (guardCheck.checkWithRayCast):
		var foundSomething: bool = false
		for i in guardCheck.raycastResult.size():
			if (guardCheck.raycastResult[i] is PlayerCharacter || guardCheck.raycastResult[i] is TailFollow):
				foundSomething = true
				determine_suspicion_type(guardCheck.raycastResult[i])
				break
		if (!foundSomething):
			state = NodeState.FAILURE
			guardCheck.playerSeen = false
	else:
		state = NodeState.FAILURE

func determine_suspicion_type(target):
	if (target is PlayerCharacter):
		guardController.guardRotator.setLookingAtPosition(target.global_position)
		if (target.transformationChangeRef.get_if_transformed_in_right_zone() == 0):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsSeenMultiplier)
			guardCheck.researchOutcome = true
			return
		if (target.velocity != Vector2.ZERO):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (target.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (guardCheck.playerSeen):
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
		return
	if (target is TailFollow):
		guardController.guardRotator.setLookingAtPosition(target.global_position)
		guardCheck.playerSeen = true
		guardCheck.researchOutcome = true
		suspicion_active(target, guardCheck.playerIsSeenMultiplier)
		return
	state = NodeState.FAILURE

func suspicion_active(target: Node2D, multiplier):
	if (guardCheck.reductionOverTimeActive == true):
		guardCheck.reductionOverTimeActive = false
	if (!guardCheck.preCheckActive && !guardController.isChecking):
		activate_preCheck(target, multiplier)
	state = NodeState.SUCCESS

func activate_preCheck(target, multiplier):
	guardCheck.preCheckActive = true
	guardCheck.preCheckTimer = guardCheck.preCheckDuration
	guardCheck.detectedTarget = target
	guardCheck.selectedMultiplier = multiplier
