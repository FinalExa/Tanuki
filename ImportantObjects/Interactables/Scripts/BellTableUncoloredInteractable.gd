extends GenericInteractable

@export var rightColor: BrushPassive.BrushColor

func ExecuteRefEffect(receivedRef):
	if (receivedRef is PlayerCharacter):
		CheckIfRightBrushColor(receivedRef)

func CheckIfRightBrushColor(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.isTransformed):
		var passive: BrushPassive = playerRef.transformationChangeRef.currentTransformationPassive
		if (passive.currentColor == rightColor):
			passive.ChangeColor(BrushPassive.BrushColor.NONE)
			ExecuteExtraEffect()
			FinalState()
