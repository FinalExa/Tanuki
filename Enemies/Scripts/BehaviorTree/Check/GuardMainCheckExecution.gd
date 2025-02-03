extends GuardNode

@export var guardCheck: GuardCheck

func Evaluate(_delta):
	return MainCheck()

func MainCheck():
	if (guardCheck.checkWithRayCast):
		for i in guardCheck.raycastResult.size():
			if (guardCheck.raycastResult[i] is PlayerCharacter):
				return DetermineSuspicionType(guardCheck.raycastResult[i])
		if (guardCheck.currentAlertValue > 0):
			guardCheck.ActivateReduction()
			return NodeState.FAILURE
	if (guardCheck.currentAlertValue > 0):
		guardCheck.ActivateReduction()
	return NodeState.FAILURE

func DetermineSuspicionType(target: PlayerCharacter):
	var playerHiddenStatus = target.transformationChangeRef.get_if_transformed_in_right_zone()
	if (!guardCheck.playerSeen && playerHiddenStatus == 1 && target.velocity == Vector2.ZERO):
		return PlayerNotSeen()
	enemyController.enemyRotator.setLookingAtPosition(target.global_position)
	if (playerHiddenStatus == 0):
		return PlayerNotTransformed(target)
	if (target.velocity != Vector2.ZERO || playerHiddenStatus == 2):
		return PlayerSuspiciousWhileTransformed(target)
	if (guardCheck.playerSeen):
		return PlayerSeenBeforeTransformation(target)
	return NodeState.FAILURE

func PlayerNotTransformed(target: PlayerCharacter):
	guardCheck.playerSeen = true
	SuspicionActive(target, guardCheck.playerIsSeenMultiplier)
	guardCheck.researchOutcome = true
	return NodeState.FAILURE

func PlayerSuspiciousWhileTransformed(target: PlayerCharacter):
	guardCheck.playerSeen = true
	SuspicionActive(target, guardCheck.playerIsNotSeenMultiplier)
	guardCheck.researchOutcome = false
	return NodeState.FAILURE

func PlayerSeenBeforeTransformation(target: PlayerCharacter):
	SuspicionActive(target, guardCheck.playerIsNotSeenMultiplier)
	guardCheck.researchOutcome = false
	return NodeState.FAILURE

func PlayerNotSeen():
	if (!guardCheck.reductionOverTimeActive): guardCheck.ActivateReduction()
	return NodeState.FAILURE

func SuspicionActive(target: Node2D, multiplier):
	if (guardCheck.reductionOverTimeActive):
		guardCheck.reductionOverTimeActive = false
	if (!guardCheck.preCheckActive && !enemyController.isChecking):
		StartPreCheck(target, multiplier)

func StartPreCheck(target, multiplier):
	guardCheck.preCheckActive = true
	guardCheck.preCheckTimer = guardCheck.preCheckDuration
	guardCheck.detectedTarget = target
	guardCheck.selectedMultiplier = multiplier
