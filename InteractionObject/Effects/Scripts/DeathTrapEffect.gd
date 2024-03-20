extends InteractionObjectEffect

@export var cooldownExtraReductionPerTick: float
@export var guardLaunchDistance: float

func execute_effect_normally(receivedBody: CharacterBody2D, _delta):
	if (receivedBody!=null):
		if (receivedBody is PlayerCharacter):
			get_tree().reload_current_scene()
		else:
			if(!receivedBody.isStunned):
				receivedBody.is_damaged(self.global_position)
				var destination: Vector2 = self.get_parent().global_position.direction_to(receivedBody.global_position)
				destination *= guardLaunchDistance
				receivedBody.translate(destination)
				receivedBody.guardMovement.set_location_target(receivedBody.global_position)

func execute_negated_effect(receivedBody: CharacterBody2D, delta):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		playerRef.transformationChangeRef.transformationTimer=clamp(playerRef.transformationChangeRef.transformationTimer + cooldownExtraReductionPerTick*delta, 0, playerRef.transformationChangeRef.transformationDuration)
