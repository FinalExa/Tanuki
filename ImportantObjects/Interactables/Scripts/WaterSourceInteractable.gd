class_name WaterSourceInteractable
extends GenericInteractable

@export var emptySprite: Sprite2D
@export var fullSprite: Sprite2D

@export var alwaysFilled: bool
@export var waterwaysToActivate: Array[Waterway]
var filledBy: Array[Waterway]

func ReadyOperations():
	CheckIfAlwaysFull()

func CheckIfAlwaysFull():
	if (alwaysFilled):
		FullMode()
	else:
		EmptyMode()

func FullMode():
	emptySprite.hide()
	fullSprite.show()

func EmptyMode():
	fullSprite.hide()
	emptySprite.show()

func CooldownActivatedEffect():
	if (filledBy.size() > 0 || alwaysFilled):
		for i in waterwaysToActivate.size():
			waterwaysToActivate[i].AddFiller(self)

func CooldownFinishedEffect():
	for i in waterwaysToActivate.size():
		waterwaysToActivate[i].RemoveFiller(self)

func GetFilled(filler):
	if (!filledBy.has(filler)):
		filledBy.push_back(filler)
		FullMode()

func GetUnfilled(filler):
	if (filledBy.has(filler)):
		filledBy.erase(filler)
		if (filledBy.size() == 0): EmptyMode()
