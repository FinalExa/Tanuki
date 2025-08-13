extends TrapObjectEffect

@export var pullForce: float
@export var distanceFromCenter: float

func NormalEffect(receivedBody: CharacterBody2D, _delta):
	if (receivedBody is PlayerCharacter):
		MoveToCenter(receivedBody)

func MoveToCenter(playerRef: PlayerCharacter):
	if (playerRef.global_position.distance_to(self.global_position) > distanceFromCenter):
		var pullSpeed: Vector2 = playerRef.global_position.direction_to(self.global_position) * pullForce
		playerRef.playerMovement.AddExternalForce(pullSpeed)
	else:
		playerRef.playerMovement.AddExternalForce(Vector2.ZERO)

func OnLeaveEffect(receivedBody: CharacterBody2D):
	if (receivedBody is PlayerCharacter):
		receivedBody.playerMovement.AddExternalForce(Vector2.ZERO)
