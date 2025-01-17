extends GuardNode

@export var guardCheck: GuardCheck

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	MainCheck()
	return state

func MainCheck():
	if (guardCheck.checkWithRayCast):
		var foundSomething: bool
		for i in guardCheck.raycastResult.size():
			if (guardCheck.raycastResult[i] is PlayerCharacter):
				foundSomething = DetermineSuspicionType(guardCheck.raycastResult[i])
				if (foundSomething): return
				else: break
		state = NodeState.FAILURE
		guardCheck.playerSeen = false
		return
	state = NodeState.FAILURE

func DetermineSuspicionType(target: PlayerCharacter):
	if (target is PlayerCharacter):
		var playerHiddenStatus = target.transformationChangeRef.get_if_transformed_in_right_zone()
		if (!(!guardCheck.playerSeen && playerHiddenStatus == 1)):
			enemyController.enemyRotator.setLookingAtPosition(target.global_position)
		if (playerHiddenStatus == 0):
			PlayerNotTransformed(target)
			return true
		if (target.velocity != Vector2.ZERO):
			PlayerSuspiciousWhileTransformed(target)
			return true
		if (playerHiddenStatus == 2):
			PlayerSuspiciousWhileTransformed(target)
			return true
		if (!guardCheck.playerSeen && playerHiddenStatus == 1):
			return false
		if (guardCheck.playerSeen):
			PlayerSeenBeforeTransformation(target)
		return true
	state = NodeState.FAILURE

func PlayerNotTransformed(target: PlayerCharacter):
	guardCheck.playerSeen = true
	SuspicionActive(target, guardCheck.playerIsSeenMultiplier)
	guardCheck.researchOutcome = true

func PlayerSuspiciousWhileTransformed(target: PlayerCharacter):
	guardCheck.playerSeen = true
	SuspicionActive(target, guardCheck.playerIsNotSeenMultiplier)
	guardCheck.researchOutcome = false

func PlayerSeenBeforeTransformation(target: PlayerCharacter):
	SuspicionActive(target, guardCheck.playerIsNotSeenMultiplier)
	guardCheck.researchOutcome = false

func SuspicionActive(target: Node2D, multiplier):
	if (guardCheck.reductionOverTimeActive):
		guardCheck.reductionOverTimeActive = false
	if (!guardCheck.preCheckActive && !enemyController.isChecking):
		StartPreCheck(target, multiplier)
	state = NodeState.SUCCESS

func StartPreCheck(target, multiplier):
	guardCheck.preCheckActive = true
	guardCheck.preCheckTimer = guardCheck.preCheckDuration
	guardCheck.detectedTarget = target
	guardCheck.selectedMultiplier = multiplier
