extends GenericInteractable

@export var partSprites: Array[Sprite2D]
var partsObtained: int
var done: bool

func ReadyOperations():
	partsObtained = 0

func ExecuteRefEffect(ref):
	if (ref is PlayerCharacter):
		RepairParts(ref)

func RepairParts(playerRef: PlayerCharacter):
	if (!done && playerRef.playerMoveObjects.currentObject is GeneratorPartMovable):
		var generatorPart: GeneratorPartMovable = playerRef.playerMoveObjects.currentObject
		if (!partSprites[generatorPart.partID].visible):
			partSprites[generatorPart.partID].show()
			partsObtained += 1
			playerRef.playerMoveObjects.DeleteLeftoverObject()
			if (partsObtained >= partSprites.size()):
				done = true
				ExecuteExtraEffect()
				FinalState()
