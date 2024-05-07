extends InteractionObjectEffect

@export var firstExitPoint: SmallGapExitPoint
@export var secondExitPoint: SmallGapExitPoint

func execute_negated_effect(receivedBody: CharacterBody2D, _delta):
	SendCharacterBack(receivedBody)

func SendCharacterBack(receivedBody: CharacterBody2D):
	if (firstExitPoint.charactersInteractingWithPoint.has(receivedBody)):
		receivedBody.global_position = firstExitPoint.global_position
		return
	if (secondExitPoint.charactersInteractingWithPoint.has(receivedBody)):
		receivedBody.global_position = secondExitPoint.global_position
