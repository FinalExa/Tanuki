extends WardenCheck

@export var hands: Array[WardenBossHand]
@export var handStartingPositions: Array[Node2D]
var currentEyes: Array[WardenBossEye]
var handsActive: bool

func _physics_process(_delta):
	if (!EyeHasSpottedPlayer()):
		WardenCheckRaycast()

func EyeHasSpottedPlayer():
	if (activated && currentEyes.size() > 0):
		raycastResult = currentEyes[0].playerRef
		return true
	return false

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
