extends Area2D

@export var interactableToOperate: GenericInteractable

var playerRef: PlayerCharacter

func _process(_delta):
	CheckForRightTransformationTag()

func CheckForRightTransformationTag():
	if (playerRef != null): 
		PlayerCheck()
		MovableCheck(playerRef.playerMoveObjects.currentObject)

func PlayerCheck():
	if (playerRef.transformationChangeRef.isTransformed):
		var selectedProperty: String
		for i in playerRef.transformationChangeRef.currentTransformationObject.transformedProperties.size():
			if (interactableToOperate.neededProperties.has(playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i])):
				selectedProperty = playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i]
				break
		if (selectedProperty != ""):
			interactableToOperate.AttackInteraction(selectedProperty)
			playerRef.transformationChangeRef.transformationActivation.DeactivateTransformation()
			playerRef.transformationChangeRef.SetNoTransformation()

func MovableCheck(movable: MovableObject):
	if (movable != null):
		var selectedProperty: String
		for i in movable.movableObjectProperties.size():
			if (interactableToOperate.neededProperties.has(movable.movableObjectProperties[i])):
				selectedProperty = movable.movableObjectProperties[i]
				break
		if (selectedProperty != ""):
			interactableToOperate.AttackInteraction(selectedProperty)
			playerRef.playerMoveObjects.DeleteLeftoverObject()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
