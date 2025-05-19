extends GenericInteractable

@export var rightColor: BrushPassive.BrushColor

@export var colors: Array[Color]
@export var parts: Array[Sprite2D]

func ReadyOperations():
	ColorParts()

func ColorParts():
	for i in parts.size():
		if (BrushPassive.BrushColor.find_key(rightColor) != BrushPassive.BrushColor.find_key(i)):
			parts[i].modulate = colors[i]
		else:
			parts[i].modulate = colors[BrushPassive.BrushColor.NONE]

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
