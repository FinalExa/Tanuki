extends GenericInteractable

var waterObtained: bool
var heated: bool
var waterwaysFillingMe: Array[Waterway]

@export var emptySprite: Sprite2D
@export var fullSprite: Sprite2D
@export var heatedSprite: Sprite2D

@export var waterwaysToActivate: Array[Waterway]

func GetFilled(filler):
	if (!waterObtained):
		if (!waterwaysFillingMe.has(filler)):
			waterwaysFillingMe.push_back(filler)
		if (visible):
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
	if (!waterObtained):
		if (waterwaysFillingMe.has(filler)):
			waterwaysFillingMe.erase(filler)

func ProcessOperations():
	WaitForActivation()

func WaitForActivation():
	if (!waterObtained && waterwaysFillingMe.size() > 0 && visible):
		ObtainWater()
		FillWaterways()

func FillWaterways():
	for i in waterwaysToActivate.size():
		waterwaysToActivate[i].AddFiller(self)

func HeatWaterways():
	for i in waterwaysToActivate.size():
		waterwaysToActivate[i].AddHeater(self)

func ExecuteRefEffect(ref):
	if (waterObtained && !heated):
		var movableRef: MovableObject = ref.playerMoveObjects.currentObject
		movableRef.ResetParentAndPosition()
		ExecuteExtraEffect()
		FinalState()

func FinalStateExtraExecution():
	waterObtained = true
	heated = true
	FillWaterways()
	HeatWaterways()
	emptySprite.hide()
	fullSprite.hide()
	heatedSprite.show()
