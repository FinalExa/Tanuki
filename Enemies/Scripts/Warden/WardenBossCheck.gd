extends WardenCheck

@export var hands: Array[WardenBossHand]
@export var handStartingPositions: Array[Node2D]
var handsActive: bool

func ReadyOperations():
	for i in hands.size():
		hands[i].wardenBossRef = wardenController

func OnWardenCheckIncrease():
	if (checkCurrentValue > checkScreamThreshold && !handsActive):
		for i in hands.size():
			hands[i].Activate(handStartingPositions[i].global_position)
		handsActive = true

func OnWardenCheckDecrease():
	if (checkCurrentValue == checkMinValue && handsActive):
		for i in hands.size():
			hands[i].Deactivate()
		handsActive = false
