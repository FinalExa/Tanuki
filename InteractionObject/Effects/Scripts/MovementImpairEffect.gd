extends InteractionObjectEffect

@export var playerSpeedWhileCaptured: float
var playerHasBeenMoved: bool = false
var playerHasBeenCaptured: bool = false

func execute_effect_normally(receivedBody, delta):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		if (!playerHasBeenCaptured):
			playerRef.movementRef.set_max_speed(playerSpeedWhileCaptured)
			if (!playerHasBeenMoved):
				playerRef.global_position = self.get_parent().global_position
				playerHasBeenMoved = true
			playerHasBeenCaptured = true
		if (playerRef.transformationChangeRef.isTransformed):
			playerRef.transformationChangeRef.deactivate_transformation()
			playerRef.movementRef.set_max_speed(playerSpeedWhileCaptured)

func execute_negated_effect(receivedBody, delta):
	if (receivedBody is PlayerCharacter):
		if (playerHasBeenCaptured):
			var playerRef: PlayerCharacter = receivedBody
			playerRef.movementRef.reset_max_speed()
			playerHasBeenCaptured = false

func execute_leave_effect(receivedBody):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		playerRef.movementRef.reset_max_speed()
		playerHasBeenCaptured = false
		playerHasBeenMoved = false
