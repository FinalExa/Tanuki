extends Area2D

@export var dirtyFloorInteractable: GenericInteractable

var playerRef: PlayerCharacter

func _process(delta):
	CheckForRightTransformationTag(playerRef)

func CheckForRightTransformationTag(playerRef: PlayerCharacter):
	if (playerRef != null): 
		if (playerRef.transformationChangeRef.isTransformed):
			var selectedProperty: String
			for i in playerRef.transformationChangeRef.currentTransformationProperties.size():
				if (dirtyFloorInteractable.neededString == playerRef.transformationChangeRef.currentTransformationProperties[i]):
					selectedProperty = playerRef.transformationChangeRef.currentTransformationProperties[i]
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
