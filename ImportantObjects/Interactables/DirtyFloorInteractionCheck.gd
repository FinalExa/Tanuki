extends Area2D

@export var dirtyFloorInteractable: GenericInteractable

var playerRef: PlayerCharacter

func _process(delta):
	CheckForRightTransformationTag(playerRef)

func CheckForRightTransformationTag(playerRef: PlayerCharacter):
	if (playerRef != null && playerRef.transformationChangeRef.isTransformed):
		var selectedProperty: String
		for i in playerRef.transformationChangeRef.currentTransformationProperties.size():
			if (dirtyFloorInteractable.neededString == playerRef.transformationChangeRef.currentTransformationProperties[i]):
				selectedProperty = playerRef.transformationChangeRef.currentTransformationProperties[i]
				break
		if (selectedProperty != ""):
			dirtyFloorInteractable.AttackInteraction(selectedProperty)
		else:
			playerRef.transformationChangeRef.DeactivateTransformation()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
