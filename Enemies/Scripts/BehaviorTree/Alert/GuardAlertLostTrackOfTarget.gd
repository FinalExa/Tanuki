extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(_delta):
	TargetNotSeen()
	return NodeState.SUCCESS

func TargetNotSeen():
	guardAlert.catchPreparationActive = false
	guardAlert.lostSightOfPlayer = true
	if (!guardAlert.firstLocationReached):
		MoveToFirstLocation()
		return
	if (!guardAlert.secondLocationReached):
		MoveToSecondLocation()
		return
	if (!guardAlert.targetNotSeenActive):
		StartNotSeenTimer()

func MoveToFirstLocation():
	var distance: float = enemyController.global_position.distance_to(guardAlert.lastTargetPosition)
	if (distance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
		guardAlert.set_movement_destination(guardAlert.lastTargetPosition)
	else:
		guardAlert.firstLocationReached = true

func MoveToSecondLocation():
	if (guardAlert.secondLocationTargetCheckLaunched == false):
		guardAlert.secondLocationTargetCheckLaunched = true
		guardAlert.extraLocationSet = false
	var extraDistance: float = enemyController.global_position.distance_to(guardAlert.extraTargetLocation)
	if (extraDistance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
		guardAlert.set_movement_destination(guardAlert.extraTargetLocation)
	else:
		guardAlert.secondLocationReached = true

func StartNotSeenTimer():
	guardAlert.targetNotSeenTimer = guardAlert.targetNotSeenDuration
	guardAlert.targetNotSeenActive = true
