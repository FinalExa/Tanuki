extends Area2D

@export var dirtyFloorInteractable: GenericInteractable

var playerRef: PlayerCharacter

func _process(_delta):
	CheckForRightTransformationTag()

func CheckForRightTransformationTag():
	if (playerRef != null): 
		if (playerRef.transformationChangeRef.isTransformed):
			var selectedProperty: String
			for i in playerRef.transformationChangeRef.currentTransformationObject.transformedProperties.size():
				if (dirtyFloorInteractable.neededProperties.has(playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i])):
					selectedProperty = playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i]
					break
			if (selectedProperty != ""):
				dirtyFloorInteractable.AttackInteraction(selectedProperty)
				return
			else:
				playerRef.transformationChangeRef.DeactivateTransformation()
		playerRef.transformationChangeRef.SetNoTransformation()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
