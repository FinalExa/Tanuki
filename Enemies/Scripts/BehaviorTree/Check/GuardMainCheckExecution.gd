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
			if (guardCheck.raycastResult[i] is PlayerCharacter):
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
		var playerHiddenStatus = target.transformationChangeRef.get_if_transformed_in_right_zone()
		if (!(!guardCheck.playerSeen && playerHiddenStatus == 1)):
			enemyController.enemyRotator.setLookingAtPosition(target.global_position)
		if (playerHiddenStatus == 0):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsSeenMultiplier)
			guardCheck.researchOutcome = true
			return
		if (target.velocity != Vector2.ZERO):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (!guardCheck.playerSeen && playerHiddenStatus == 1):
			return
		if (playerHiddenStatus == 2):
			guardCheck.playerSeen = true
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
			return
		if (guardCheck.playerSeen):
			suspicion_active(target, guardCheck.playerIsNotSeenMultiplier)
			guardCheck.researchOutcome = false
		return
	state = NodeState.FAILURE

func suspicion_active(target: Node2D, multiplier):
	if (guardCheck.reductionOverTimeActive == true):
		guardCheck.reductionOverTimeActive = false
	if (!guardCheck.preCheckActive && !enemyController.isChecking):
		activate_preCheck(target, multiplier)
	state = NodeState.SUCCESS

func activate_preCheck(target, multiplier):
	guardCheck.preCheckActive = true
	guardCheck.preCheckTimer = guardCheck.preCheckDuration
	guardCheck.detectedTarget = target
	guardCheck.selectedMultiplier = multiplier
