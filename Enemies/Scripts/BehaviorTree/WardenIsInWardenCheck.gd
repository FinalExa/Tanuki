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
	if (enemyController.enemyRotator.isLookingAtNode && enemyController.enemyRotator.target is PlayerCharacter):
		enemyController.enemyRotator.stopLooking()
	if (wardenCheck.alertGuardsArea.get_parent() == wardenCheck):
		wardenCheck.RemoveArea()
	if (!enemyController.isInPatrol):
		enemyController.enemyPatrol.resume_patrol()
	return NodeState.SUCCESS

func CheckForPlayerCurrentHiddenStatus(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.get_if_transformed_in_right_zone() != 1 ||
	(playerRef.transformationChangeRef.get_if_transformed_in_right_zone() == 1 && playerRef.velocity != Vector2.ZERO)):
		return true
