extends GuardNode

@export var guardCheck: GuardCheck
var previousRaycastArray: Array[Node2D]
var previousResult: Node2D

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	main_check()
	return state

func main_check():
	if (previousRaycastArray != guardCheck.raycastResult):
		var foundSomething: bool = false
		for i in guardCheck.raycastResult.size():
			if (guardCheck.raycastResult[i] is PlayerCharacter || guardCheck.raycastResult[i] is TailFollow):
				foundSomething = true
				previousResult = guardCheck.raycastResult[i]
				determine_suspicion_type(guardCheck.raycastResult[i])
				break
		if (!foundSomething):
			state = NodeState.FAILURE
			guardCheck.playerSeen = false
			previousResult = null
		previousRaycastArray = guardCheck.raycastResult
	else:
		if (previousResult == null):
			state = NodeState.FAILURE
		else:
			determine_suspicion_type(previousResult)

func determine_suspicion_type(target):
	if (target is PlayerCharacter):
		guardController.guardRotator.setLookingAtPosition(target.global_position)
		if (target.transformationChangeRef.get_if_transformed_in_right_zone() == 0):
			print("not transformed")
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsSeenMultiplier)
			guardCheck.researchOutcome = true
			return
		if (target.velocity != Vector2.ZERO):
			print("transformed but moving")
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (target.transformationChangeRef.get_if_transformed_in_right_zone() == 2):
			print("transformed, still and wrong transformation")
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (guardCheck.playerSeen):
			print("player was seen")
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
		return
	if (target is TailFollow):
		print("tail spotted")
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
