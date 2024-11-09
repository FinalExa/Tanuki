extends GuardNode

@export var wardenCheck: WardenCheck
var playerSpotted: bool

func Evaluate(delta):
	if (wardenCheck.raycastResult is PlayerCharacter):
		playerSpotted = CheckForPlayerCurrentHiddenStatus(wardenCheck.raycastResult)
		if (playerSpotted):
			enemyController.enemyPatrol.stop_patrol()
			enemyController.enemyRotator.setLookingAtNode(wardenCheck.playerRef)
			return NodeState.FAILURE
	playerSpotted = false
	wardenCheck.DecreaseCheckValue(delta)
	wardenCheck.CheckToRemoveArea()
	if (!enemyController.isInPatrol):
		enemyController.enemyPatrol.resume_patrol()
	return NodeState.SUCCESS

func CheckForPlayerCurrentHiddenStatus(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.get_if_transformed_in_right_zone() != 1 ||
	(playerRef.transformationChangeRef.get_if_transformed_in_right_zone() == 1 && playerRef.velocity != Vector2.ZERO)):
		return true
