extends GuardNode

@export var wardenCheck: WardenCheck
@export var wardenDecreaseICD: float = 1.5
var timer: float

func Evaluate(delta):
	if (wardenCheck.raycastResult != null && wardenCheck.raycastResult is PlayerCharacter):
		wardenCheck.playerSpotted = CheckForPlayerCurrentHiddenStatus(wardenCheck.raycastResult)
		if (wardenCheck.playerSpotted):
			timer = wardenDecreaseICD
			enemyController.enemyPatrol.stop_patrol()
			enemyController.enemyRotator.setLookingAtNode(wardenCheck.playerRef)
			return NodeState.FAILURE
		DecreaseAndResetWarden(delta)
		return NodeState.SUCCESS
	else:
		DecreaseTimer(delta)
	return NodeState.SUCCESS

func DecreaseTimer(delta):
	if (timer > 0):
		timer -= delta
		return
	DecreaseAndResetWarden(delta)

func DecreaseAndResetWarden(delta):
	wardenCheck.playerSpotted = false
	wardenCheck.DecreaseCheckValue(delta)
	if (wardenCheck.checkCurrentValue < wardenCheck.checkScreamThreshold):
		wardenCheck.CheckToRemoveArea()
		if (!enemyController.isInPatrol):
			enemyController.enemyPatrol.resume_patrol()

func CheckForPlayerCurrentHiddenStatus(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.get_if_transformed_in_right_zone() != 1 ||
	(playerRef.transformationChangeRef.get_if_transformed_in_right_zone() == 1 && playerRef.velocity != Vector2.ZERO)):
		return true
	return false
