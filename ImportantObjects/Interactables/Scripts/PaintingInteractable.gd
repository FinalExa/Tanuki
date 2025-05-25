class_name PaintingInteractable
extends GenericInteractable

@export var colors: Array[Color]
@export var parts: Array[Sprite2D]
var obtainedColors: Array[BrushPassive.BrushColor]

func ReadyOperations():
	SetupParts()

func SetupParts():
	for i in parts.size():
		parts[i].hide()
	obtainedColors.clear()

func ExecuteRefEffect(receivedRef):
	if (receivedRef is PlayerCharacter):
		CheckIfRightBrushColor(receivedRef)

func CheckIfRightBrushColor(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.isTransformed):
		var passive: BrushPassive = playerRef.transformationChangeRef.currentTransformationPassive
		if (passive.currentColor != BrushPassive.BrushColor.NONE && !obtainedColors.has(passive.currentColor)):
			parts[passive.currentColor].show()
			obtainedColors.push_back(passive.currentColor)
			passive.ChangeColor(BrushPassive.BrushColor.NONE)
			Finalize()

func Finalize():
	if (obtainedColors.size() == parts.size()):
		ExecuteExtraEffect()
		FinalState()
