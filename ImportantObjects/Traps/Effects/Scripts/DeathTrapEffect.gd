extends InteractionObjectEffect

@export var cooldownExtraReductionPerTick: float
@export var guardLaunchDistance: float

func execute_effect_normally(receivedBody: CharacterBody2D, _delta):
	if (receivedBody != null):
		if (receivedBody is PlayerCharacter):
			receivedBody.GameOver(self)
			return
		if (receivedBody is EnemyController && !receivedBody.isStunned):
			var destination: Vector2 = self.get_parent().global_position.direction_to(receivedBody.global_position)
			receivedBody.is_damaged(self.global_position, EnemyStunned.StunTier.MEDIUM)
			destination *= guardLaunchDistance
			receivedBody.translate(destination)
			receivedBody.enemyMovement.set_location_target(receivedBody.global_position)

func execute_negated_effect(receivedBody: CharacterBody2D, delta):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		playerRef.transformationChangeRef.transformationTimer=clamp(playerRef.transformationChangeRef.transformationTimer + cooldownExtraReductionPerTick*delta, 0, playerRef.transformationChangeRef.transformationDuration)
