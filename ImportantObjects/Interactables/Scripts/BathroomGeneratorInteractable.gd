extends GenericInteractable

var waterObtained: bool
var heated: bool

@export var emptySprite: Sprite2D
@export var fullSprite: Sprite2D
@export var heatedSprite: Sprite2D

@export var waterwaysToActivate: Array[Waterway]

func GetFilled(filler):
	if (!waterObtained):
		ObtainWater()
		FillWaterways()

func ObtainWater():
	waterObtained = true
	emptySprite.hide()
	fullSprite.show()

func ObtainHeat():
	heated = true
	fullSprite.hide()
	heatedSprite.show()

func GetUnfilled(filler):
	pass

func FillWaterways():
	for i in waterwaysToActivate.size():
		waterwaysToActivate[i].AddFiller(self)

func ExecuteRefEffect(ref):
	if (waterObtained && !heated):
		var movableRef: MovableObject = ref.playerMoveObjects.currentObject
		movableRef.ResetParentAndPosition()
		ExecuteExtraEffect()
		FinalState()

func FinalStateExtraExecution():
	waterObtained = true
	heated = true
	emptySprite.hide()
	fullSprite.hide()
	heatedSprite.show()
